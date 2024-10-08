use "collections"
use "runtime_info"
use "cli"

actor Worker 
  be calculate(startind: U64, k: U64, endind: U64, env : Env , boss: Boss) =>
    var sum: U64 = 0
    // Initial sum for the first window
    let utils = Utilities

    /*for i in Range[U64](startind,startind + (k)) do
      sum = sum + (i * i)
    end*/
    var m = startind
    var n = startind + (k-1)
    sum = ((((n * (n + 1)) * ((2 * n) + 1)) - (((m - 1) * m) * ((2 * m) - 1))) / 6)

    //env.out.print(sum.string())
   // Printer.print(sum,env)
    // Check if the sum is a perfect square
    var value = utils.sqrt(sum)
   // Printer.print(value,env)
    if (value * value) == sum then
      env.out.print(startind.string() + " s = "+ value.string())
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

    let cs =
      try
        CommandSpec.leaf("echo", "A sample echo program", [
          OptionSpec.bool("lukas", "lukas square Pyramid"
            where short' = 'L', default' = false)
        ], [
          ArgSpec.u64("num1", "Value of N")
          ArgSpec.u64("num2", "Valur of K")
        ])? .> add_help()?
      else
        env.exitcode(-1)  // some kind of coding error
        return
      end
    let cmd =
      match CommandParser(cs).parse(env.args, env.vars)
      | let c: Command => c
      | let ch: CommandHelp =>
          ch.print_help(env.out)
          env.exitcode(0)
          return
      | let se: SyntaxError =>
          env.out.print(se.string())
          env.exitcode(1)
          return
      end
    let num1 = cmd.arg("num1").u64()
    let num2 = cmd.arg("num2").u64()

    

    let total_workers: U32 = Scheduler.schedulers(SchedulerInfoAuth(env.root)) // Total worker count based on available processors

    let boss = Boss(env, total_workers.u64())
    boss.start(num1, num2, env)



    