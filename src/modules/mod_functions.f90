! Copyright 2023 FortAI-Hub contributors.
! Released under the MIT License. See LICENSE file for full license information.

module mod_functions
    use mod_real_precision
    implicit none
    private
    public :: sigmoid, relu, softmax_2d, softmax_1d, argmax, layer_norm_2d, layer_norm_1d

contains

    elemental real(sp) function sigmoid(x)
        real(sp), intent(in) :: x
        sigmoid = 1.0 / (1.0 + exp(-x))
    end function

    elemental real(sp) function relu(x)
        real(sp), intent(in) :: x
        relu = max(0.0, x)
    end function

    function softmax_2d(x) result(y)
        real(sp), intent(in) :: x(:,:)
        real(sp) :: y(size(x,1),size(x,2))
        integer :: i
        do i = 1, size(x,2)
            y(:,i) = exp(x(:,i) - maxval(x(:,i)))
            y(:,i) = y(:,i) / sum(y(:,i))
        end do
    end function

    pure function softmax_1d(x) result(y)
        implicit none
        real(sp), intent(in) :: x(:)
        real(sp) :: y(size(x))
        y = exp(x - maxval(x))
        y = y / sum(y)
    end function

    function argmax(x) result(max_index)
        real(sp), intent(in) :: x(:)
        integer :: max_index
        max_index = maxloc(x, dim=1)
    end function

    pure function layer_norm_2d(x, g, b, eps) result(y)
        real(sp), intent(in) :: x(:,:), g(:), b(:), eps

        real(sp) :: y(size(x,1),size(x,2))
        real(sp) :: mean(size(x,2))
        real(sp) :: diff(size(x,1))
        real(sp) :: variance

        integer :: input_size, batch_size, i

        input_size = size(x, 1)
        batch_size = size(x, 2)

        mean = sum(x, dim=1) / input_size

        do concurrent (i = 1:batch_size)
            diff = x(:,i) - mean(i)
            variance = sum(diff**2) / input_size
            y(:,i) = diff / sqrt(variance + eps) * g + b
        end do
    end function

    pure function layer_norm_1d(x, g, b, eps) result(y)
        real(sp), intent(in) :: x(:)
        real(sp), intent(in) :: g(:), b(:)  ! Scale factor and bias
        real(sp), intent(in) :: eps
        real(sp) :: y(size(x))
        real(sp) :: mean, variance
        integer :: input_size

        input_size = size(x)

        mean = sum(x) / input_size
        variance = sum((x - mean)**2) / input_size
        y = (x - mean) / sqrt(variance + eps) * g + b
    end function

end module
