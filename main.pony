use "collections"
use "runtime_info"

actor Worker 
  be calculate(startind: U64, k: U64, endind: U64, env : Env , boss: Boss) =>
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
      env.out.print("1 s = " + value.string())
    end

    

    //Slide the window across the range
    for i in Range[U64](startind + 1,endind+1) do
      sum = sum + (((i + (k - 1)) * (i + (k - 1))) - ((i - 1) * (i - 1)))
      value = utils.sqrt(sum)
      if (value * value) == sum then
        env.out.print(i.string() + " s = " + value.string())
      end
    end

    boss.completed(env)

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
  var _completed: U64 = 0
  var _total_workers: U64
  var _workers: Array[Worker] ref = Array[Worker].create()
  new create(env: Env, total_workers: U64) =>
    _total_workers = total_workers
    // Create worker actors
    for i in Range[U64](0, total_workers) do
      _workers.push(Worker)
    end

  be start(n: U64, k: U64,env:Env) =>
    var split: U64 = n / _total_workers     // each Split has to minimun of size k 
    if split < k then
      split = k
    end

    var startind: U64 = 1
    let size : USize = _workers.size() 
    var i : U64 = 0
    // Distribute tasks to worker actors
    for iworker in _workers.values() do
      if i == (size.u64() - 1) then
        iworker.calculate(startind, k, n, env, this)
      else
        iworker.calculate(startind, k, startind + (split - 1), env, this)
        startind = startind + split
        i = i + 1
      end
    end

  be completed(env:Env) =>
    _completed = _completed + 1
    if _completed == _total_workers then
      env.out.print("All workers completed")
    end

actor Main
  new create(env: Env) =>
    let n: U64 = 1000000000 
    let k: U64 = 4 //  window size

    let total_workers: U32 = 100  // Total worker count based on available processors

    let boss = Boss(env, total_workers.u64())
    boss.start(n, k, env)

//Things to do:
// 1) Need to some how calculate the time, i.e how the program is taking to complete the task amd metrics Prof asked 
// 2) write code which allows to take input from command line instead of hardcoding the inputs
// 3) make a readme file with all the metrics and everything needed to run file
/* 4) if still there is still time left we can do some optimization in worker actor by calculating sum of squares using sum of n
      N squares formula 
*/

    