!
!    GGI_TLM Time domain electromagnetic field solver based on the TLM method
!    Copyright (C) 2013  Chris Smartt
!
!    This program is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    This program is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with this program.  If not, see <http://www.gnu.org/licenses/>.   
!
! SUBROUTINE transmission_cross_section
!
! NAME
!    transmission_cross_section
!
! DESCRIPTION
!     
!     
! COMMENTS
!     
!
! HISTORY
!
!     started 8/02/2013 CJS
!
!
SUBROUTINE transmission_cross_section


USE post_process
USE file_information
USE constants

IMPLICIT NONE

! local variables
  
  real*8	:: Pt,E_RMS,Sc,Si,TCS,Pscale
  
  integer	:: function_number
  integer	:: n_frequencies
  integer	:: frequency_loop
  
  character	:: ch
  
! START

!  write(*,*)'Transmission Cross Section calculation'
  
  write(*,*)' '
  write(*,*)'Result=Transmitted_power/Incident_power_density'
  write(*,*)' '

  n_functions_of_time=0
  n_functions_of_frequency=3
  
  CALL Allocate_post_data()
  
  write(*,*)'File for transmitted power:'
  write(post_process_info_unit,*)'	File for transmitted power:'
  function_number=1
  CALL read_frequency_domain_data(function_number)
  
  write(*,*)'File for cavity field data:'
  write(post_process_info_unit,*)'	File for cavity field data:'
  function_number=2
  CALL read_frequency_domain_data(function_number)

! Find out if this is an E field or an H field
  write(*,*)'Is this an E or H field? (e/h)'
  read(*,'(A)')ch
  write(record_user_inputs_unit,'(A)')ch
  if ( (ch.eq.'E').OR.(ch.eq.'e') ) then
    write(post_process_info_unit,*)'	E field data'
    Pscale=1d0/Z0
  else
    write(post_process_info_unit,*)'	H field data'
    Pscale=Z0
  end if  

! check that the frequencies match...

  if (function_of_frequency(1)%n_frequencies.NE.function_of_frequency(2)%n_frequencies) then
    write(*,*)'Frequency mismatch in functions f1 and f2'
    write(*,*)'n_frequencies, f1=',function_of_frequency(1)%n_frequencies
    write(*,*)'n_frequencies, f2=',function_of_frequency(2)%n_frequencies
    STOP
  end if
  
  do frequency_loop=1,function_of_frequency(1)%n_frequencies
  
    if ( function_of_frequency(1)%frequency(frequency_loop).NE.	&
         function_of_frequency(2)%frequency(frequency_loop) ) then
	 
      write(*,*)'Frequency mismatch in functions f1 and f2'
      write(*,*)'frequency number',frequency_loop
      write(*,*)'frequency, f1=',function_of_frequency(1)%frequency(frequency_loop)
      write(*,*)'frequency, f2=',function_of_frequency(2)%frequency(frequency_loop)
      STOP
      
    end if
  
  end do

! Allocate memory for result

  n_frequencies=function_of_frequency(1)%n_frequencies
  function_number=3
  
  function_of_frequency(function_number)%n_frequencies=n_frequencies
  
  ALLOCATE ( function_of_frequency(function_number)%frequency(1:n_frequencies) )
  function_of_frequency(function_number)%frequency(1:n_frequencies)=		&
                function_of_frequency(1)%frequency(1:n_frequencies)
     
  ALLOCATE ( function_of_frequency(function_number)%value(1:n_frequencies) )
  ALLOCATE ( function_of_frequency(function_number)%magnitude(1:n_frequencies) )
  ALLOCATE ( function_of_frequency(function_number)%phase(1:n_frequencies) )
  ALLOCATE ( function_of_frequency(function_number)%dB(1:n_frequencies) )
  
  do frequency_loop=1,n_frequencies
  
    Pt   =abs(dble(function_of_frequency(1)%value(frequency_loop)))
    E_RMS=function_of_frequency(2)%magnitude(frequency_loop)/sqrt(2d0)
    
    Sc=3d0*(E_RMS**2)*Pscale
    Si=Sc/2d0
    TCS=Pt/Si
    
    function_of_frequency(function_number)%value(frequency_loop)=cmplx(TCS)
    
    function_of_frequency(function_number)%magnitude(frequency_loop)=	&
                    abs(function_of_frequency(function_number)%value(frequency_loop))
    function_of_frequency(function_number)%phase(frequency_loop)=	&
                    atan2( imag(function_of_frequency(function_number)%value(frequency_loop)), &
                           dble(function_of_frequency(function_number)%value(frequency_loop))   )
    function_of_frequency(function_number)%dB(frequency_loop)=	&
                    10d0*log10(function_of_frequency(function_number)%magnitude(frequency_loop))

  end do ! next frequency value
  
  CALL write_Frequency_Domain_Data(function_number)

  CALL Deallocate_post_data()

  RETURN
  

  
END SUBROUTINE transmission_cross_section
