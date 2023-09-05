! Copyright 2023 FortAI-Hub contributors.
! Released under the MIT License. See LICENSE file for full license information.

module mod_timer
    use iso_fortran_env, only: error_unit, int64, real64
    implicit none
    
    private

    public :: timer

    type :: timer
        integer(int64), private :: initial_count
    contains
        procedure :: done => timer_done
    end type

    interface timer
        module procedure :: timer_constructor
    end interface

contains

    type(timer) function timer_constructor(message) result(self)
        character(*), intent(in) :: message
        call system_clock(self%initial_count)
        write(error_unit,'(3a)') '> ', message, '...'
    end function

    subroutine timer_done(self)
        class(timer), intent(in) :: self
        integer(int64) :: final_count, count_rate, diff
        real(real64) :: elapsed
        call system_clock(final_count, count_rate)
        diff = final_count - self%initial_count
        elapsed = real(diff, real64) / real(count_rate, real64)
        write(error_unit,'(a, f0.6, a)') '  done. (', elapsed, 's)'
    end subroutine

end module
