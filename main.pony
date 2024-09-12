use "collections"
actor Worker 
  be calculate(startind: U64, k: U64, endind: U64, env : Env) =>
    var sum: U64 = 0
    // Initial sum for the first window
    let utils = Utilities

    for i in Range[U64](startind,startind + (k)) do
      sum = sum + (i * i)
    end
   // Printer.print(sum,env)
    // Check if the sum is a perfect square
    var value = utils.sqrt(sum)
   // Printer.print(value,env)
    if (value * value) == sum then
      env.out.print("1")
    end

    //Slide the window across the range
    for i in Range[U64](startind + 1,endind+1) do
      sum = sum + (((i + (k - 1)) * (i + (k - 1))) - ((i - 1) * (i - 1)))
      value = utils.sqrt(sum)
      if (value * value) == sum then
        env.out.print(i.string() + " s = " + value.string())
      end
    end

    // Inform boss that this worker has completed its task
class Utilities
  fun print(value: U64,env: Env)=>
    env.out.print(value.string())
  
  fun sqrt(x: U64): U64 =>
    if x == 0 then
      0
    else
      var low: U64 = 1
      var high: U64 = x
      var ans: U64 = 0

      while low <= high do
        let mid: U64 = low + ((high - low) / 2)
        let mid_squared: U64 = mid * mid

        if mid_squared == x then
          return mid
        elseif mid_squared < x then
          low = mid + 1
          ans = mid
        else
          high = mid - 1
        end
      end
      ans
    end

actor Boss 
  new create ()

actor Main
  new create(env: Env) =>
  var worker = Worker
  worker.calculate(1,24,40,env)

    