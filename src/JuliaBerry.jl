module JuliaBerry
using PiGPIO

include("explorerhat.jl")
# package code goes here

abstract type Thing

struct Pin
    pin::Int

    function Pin(pin, mode)
        PiGPIO.set_mode(_pi, pin, mode)
        new(pin)
    end
end

InputPin(pin) = Pin(pin, PiGPIO.INPUT)
OutputPin(pin) = Pin(pin, PiGPIO.OUTPUT)

struct LED <: Thing
    pin::Int

    function LED(pin)
        PiGPIO.set_mode(_pi, pin, PiGPIO.OUTPUT)
        new(pin)
    end
end

function on(x::Thing)
    PiGPIO.write(_pi, x.pin, 1)
end

function off(x::Thing)
    PiGPIO.write(_pi, x.pin, 0)
end

on(x::Array{T}) where T<:Thing = on.(x)
of(x::Array{T}) where T<:Thing = off.(x)

struct Motor <: Thing
    fw_pin::Int
    bw_pin::Int

    function Motor(fw_pin, bw_pin)
        PiGPIO.set_mode(_pi, fw_pin, PiGPIO.OUTPUT)
        PiGPIO.set_mode(_pi, bw_pin, PiGPIO.OUTPUT)
        PiGPIO.set_PWM_range(_pi, fw_pin, 100)
        PiGPIO.set_PWM_range(_pi, bw_pin, 100)
        PiGPIO.set_PWM_dutycycle(_pi, fw_pin, 0)
        PiGPIO.set_PWM_dutycycle(_pi, bw_pin, 0)
    end
end

function speed(x::Motor, speed::Int=100)
    if speed>0
        forward(x, speed)
    else if speed<0
        backward(x, abs(speed)
    end
end

function stop(x::Motor)
    PiGPIO.set_PWM_dutycycle(_pi, x.fw_pin, 0)
    PiGPIO.set_PWM_dutycycle(_pi, x.bw_pin, 0)
end

function forward(x::Motor, speed::Int)
    PiGPIO.set_PWM_dutycycle(_pi, x.fw_pin, speed)
    PiGPIO.set_PWM_dutycycle(_pi, x.bw_pin, 0)
end

function backward(x::Motor, speed::Int)
    PiGPIO.set_PWM_dutycycle(_pi, x.fw_pin, 0)
    PiGPIO.set_PWM_dutycycle(_pi, x.bw_pin, speed)
end


end # module
