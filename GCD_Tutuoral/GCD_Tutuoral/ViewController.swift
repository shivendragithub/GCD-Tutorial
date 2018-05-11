/*Here is a summary of this experiments

Remember using GCD you are only adding task to the Queue and performing task from that queue. Queue dispatches your task either in main or background thread depending on whether operation is synchronous or asynchronous. Types of queues are Serial,Concurrent,Main dispatch queue.All the task you perform is done by default from Main dispatch queue.There are already four predefined global concurrent queues for your application to use and one main queue(DispatchQueue.main).You can also manually create your own queue and perform task from that queue.

UI Related task should always be performed from main thread by dispatching the task to Main queue.Short hand utility is DispatchQueue.main.sync/async whereas network related/heavy operations should always be done asynchronously no matters which ever thread you are using either main or background*/


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func doLongAsyncTaskInSerialQueue() {
        
//        Task will run in different thread(other than main thread) when you use async in GCD. Async means execute next line do not wait until the block executes which results non blocking main thread & main queue. Since its serial queue, all are executed in the order they are added to serial queue.Tasks executed serially are always executed one at a time by the single thread associated with the Queue.
        
        let serialQueue = DispatchQueue(label: "com.queue.Serial")
        for i in 1...5 {
            serialQueue.async {
                print("\n\n\n\ndoLongAsyncTaskInSerialQueue = \(i)\n-->")
                if Thread.isMainThread{
                    print("task running in main thread")
                }else{
                    print("task running in background thread")
                    //                print("\(Thread.tit)")
                }
                let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
                let _ = try! Data(contentsOf: imgURL)
                print("\(i) completed downloading")
            }
            print("\(i) executing")


        }
    }
    
    
    func doLongSyncTaskInSerialQueue() {
//        Task may run in main thread when you use sync in GCD. Sync runs a block on a given queue and waits for it to complete which results in blocking main thread or main queue.Since the main queue needs to wait until the dispatched block completes, main thread will be available to process blocks from queues other than the main queue.Therefore there is a chance of the code executing on the background queue may actually be executing on the main thread Since its serial queue, all are executed in the order they are added(FIFO).
        
        
        let serialQueue = DispatchQueue(label: "com.queue.Serial")
        for i in 1...5 {
            serialQueue.sync {
                print("\n\n\n\ndoLongSyncTaskInSerialQueue = \(i)\n-->")
                if Thread.isMainThread{
                    print("task running in main thread")
                }else{
                    print("task running in background thread")
                }
                let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
                let _ = try! Data(contentsOf: imgURL)
                print("\(i) completed downloading")
            }
            print("\(i) executing")


        }
    }
    
    func doLongASyncTaskInConcurrentQueue() {
//        Task will run in background thread when you use async in GCD. Async means execute next line do not wait until the block executes which results non blocking main thread. Remember in concurrent queue, task are processed in the order they are added to queue but with different threads attached to the queue. Remember they are not supposed to finish the task as the order they are added to the queue.Order of task differs each time threads are created as necessarily automatically.Task are executed in parallel. With more than that(maxConcurrentOperationCount) is reached, some tasks will behave as a serial until a thread is free.
        
        
        let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
        for i in 1...5 {
            concurrentQueue.async {
                print("\n\n\n\ndoLongASyncTaskInConcurrentQueue = \(i)\n-->")
                
                if Thread.isMainThread{
                    print("task running in main thread")
                }else{
                    print("task running in background thread")
                }
                let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
                let _ = try! Data(contentsOf: imgURL)
                print("\(i) completed downloading")
            }
            print("\(i) executing")
        }
    }
    
    func doLongSyncTaskInConcurrentQueue() {
//        Task may run in main thread when you use sync in GCD. Sync runs a block on a given queue and waits for it to complete which results in blocking main thread or main queue.Since the main queue needs to wait until the dispatched block completes, main thread will be available to process blocks from queues other than the main queue.Therefore there is a chance of the code executing on the background queue may actually be executing on the main thread. Since its concurrent queue, tasks may not finish in the order they are added to queue. But with synchronous operation it does although they may be processed by different threads. So, it behaves as this is the serial queue.
        
        let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
        for i in 1...5 {
            concurrentQueue.sync {
                print("\n\n\n\ndoLongASyncTaskInConcurrentQueue = \(i)\n-->")
                
                if Thread.isMainThread{
                    print("task running in main thread")
                }else{
                    print("task running in background thread")
                }
                let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
                let _ = try! Data(contentsOf: imgURL)
                print("\(i) completed downloading")
            }
            print("\(i) executed")
        }
    }
    
    func doMultipleSyncTaskWithinAsynchronousOperation() {
//        However, There are cases you need to perform network calls operations synchronously in a background thread without freezing UI(e.g.refreshing OAuth Token and wait if it succeed or not).You need to wrap that method inside a asynchronous operation.This way your heavy operations are executed in the order and without Blocking main thread.
        
        
        let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
        concurrentQueue.async {
            let concurrentQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
            print("\n\n\n\ndoMultipleSyncTaskWithinAsynchronousOperation_firstAsync = \n-->")
            
            if Thread.isMainThread{
                print("task running in main thread")
            }else{
                print("task running in background thread")
            }
            for i in 1...5 {
                concurrentQueue.sync {
                    print("\n\n\n\ndoMultipleSyncTaskWithinAsynchronousOperation_firstSync = \(i)\n-->")
                    
                    if Thread.isMainThread{
                        print("task running in main thread")
                    }else{
                        print("task running in background thread")
                    }
                    let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
                    let _ = try! Data(contentsOf: imgURL)
                    print("\(i) completed downloading")
                }
                print("\(i) executed")
            }
            print("concurrent Queue executing")
        }
    }
    
    
    @IBAction func doLongAsyncTaskInSerialQueue_action(_ sender: UIButton) {
        printData_1()
        doLongAsyncTaskInSerialQueue()
        printData_2()
    }
    @IBAction func doLongSyncTaskInSerialQueue_action(_ sender: UIButton) {
        printData_1()
        doLongSyncTaskInSerialQueue()
        printData_2()
    }
    @IBAction func doLongASyncTaskInConcurrentQueue_action(_ sender: UIButton) {
        printData_1()
        doLongASyncTaskInConcurrentQueue()
        printData_2()
    }
    @IBAction func doLongSyncTaskInConcurrentQueue_action(_ sender: UIButton) {
        printData_1()
        doLongSyncTaskInConcurrentQueue()
        printData_2()
    }
    
    @IBAction func doMultipleSyncTaskWithinAsynchronousOperation_action(){
        printData_1()
        doMultipleSyncTaskWithinAsynchronousOperation()
        printData_2()
    }
    func printData_1(){
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
    }
    func printData_2(){
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
        print("Hello, playground")
    }
}

