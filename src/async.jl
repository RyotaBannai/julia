#=
@async x is equivalent to schedule(@task x).

wait(@async my_task())
=#

my_task = () -> begin
    sleep(1)
    println("done")
end

t = @task my_task()

t2 = Task(my_task)

function producer(c::Channel)
    put!(c, "Start")
    foreach(n -> put!(c, 2n), 1:4)
    put!(c, "Stop")
end

for x in Channel(producer)
    println(x)
end
