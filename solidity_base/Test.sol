// SPDX-License-Identifier: MIT
pragma solidity ~0.8.0;
import "./StructDeclaration.sol";

// Solidity经典用例
contract Test {
    
    string public Hello = 'hello';

    uint256 public count;
    //---------------

    bool public isShow = false;

    string public name = '';

    /*
     int8 -2**7 --- 2**7 -1
     int256 -2**255 --- 2**255 -1
    */
    int public age = 30;

    /*
     默认256  没有符号（+ -）
     unit8 => 0 - (2 ** 8 - 1)

     unit256 => 0 - (2 ** 256 - 1)
    */
    uint public count2 = 0;

    int256 public minInt = type(int256).min;
    int256 public maxInt = type(int256).max;
    
    // address  16进制20位，keccack256
    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    // 固定长字节
    bytes2 public b = hex"1000";

    // 默认值
    bool public defaultBoo; // false
    uint256 public defaultUint; // 0
    int256 public defaultInt; // 0
    address public defaultAddr; // 0x0000000000000000000000000000000000000000


    /*
     变量
     三种类型变量
     local  : 在函数中声明 仅在函数运行期间存在 不存储在区块链上 临时保存在memory 或 stack 中 函数执行完成后自动销毁 常用于临时计算或中间值存储
     global : 预定义的特殊变量 提供区块链和交易上下文信息  不占用合约存储空间 值由区块链运行时动态生成 仅可读取 不可修改 在任何地方都可访问
     state  : 在函数外部声明 永久存储在区块链上
    */
    function doSomething() public view {
        // local
        uint256 i = 456;
        // global
        uint256 timestamp = block.timestamp; // 返回当前区块的时间戳（以秒为单位），表示当前区块被挖出的时间。
        address sender = msg.sender; // 返回调用该函数的地址（即交易发送者的地址）。
    }
    
    /*
     常量 constant
     无法修改 使用常量可节省gas
    */
    address constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;

    /*
     不可变量 immutable
     不可变变量类似于常量。不可变变量的值可以在构造函数中设置，但之后不能修改
    */
    // address public immutable MY_ADDRESS1;

    // constructor(uint256 _myUint) {
    //     MY_ADDRESS1 = msg.sender;
    // }

    /*
     读取和写入 State 变量
    */
    function set(uint256 _count) public {
        count = count;
    }
    // 读取不消耗
    function get() public view returns (uint256) {
        return count;
    }

    /*
     Ether 和 Wei
     交易由 ether 以太币支付
    */
    uint256 public oneWei = 1 wei;
    // 1 wei to 1
    bool public isOneWei = (oneWei == 1);

    uint256 public oneGwei = 1 gwei;
    // 1 gwei  10^9 gwei
    bool public isOneGwei = (oneGwei == 1e9);

    uint256 public oneEther = 1 ether;
    // 1 ether  10^18 wei
    bool public isOneEther = (oneEther == 1e18);


    /*
     gas
     gas spent * gas price 需要支付的费用
     gas: 计量单位
     gas Spent: 是交易中使用的 Gas 总量
     gas price: 是你愿意为每 gas 支付多少以太币
     gas 价格较高的交易具有更高的优先级，可以包含在区块中。
     未使用的 gas 将被退还。

     Gas 限制（2个上限）
     Gas Limit（自己愿意用于交易的最大 Gas 量，由自己设置）
     block gas limit（区块中允许的最大 Gas 量，由网络设置）
    */
    // uint256 public i = 0;

    // 使用完所有发送的 gas 会导致交易失败。
    // 状态的更改将被回滚。
    // 已经消耗的 gas 不会被退还。
    // function forever() public {
    //     // 这里运行一个无限循环，直到所有 gas 被消耗完
    //     // 并且交易失败 
    //     while (true) {
    //         i += 1;
    //     }
    // }

    /*
     if(bool) {} else {}
     bool ? 1 : 0
    */

    /*
     for       while do {} while()
    */
    function loop() public {
        for (uint256 ii = 0; ii < 10; ii++) {
            if (ii == 3) {
                // 跳过本次存循环 进入下一次
                continue;
            }
            if (ii == 5) {
                // 终止循环
                break;
            }
        }

        // while loop
        uint256 jj;
        while (jj < 10) {
            jj++;
        }

        uint256 z;
        do{
            z++;
        } while (z < 10);
    }

    /*
     mapping 映射
     mapping（keyType => valueType）
     keyType可以是任何内置值类型、字节、字符串或任何设定
     valueType 可以是任何类型 包括另一个映射或数组
     映射不可迭代
    */
    // Mapping from address to uint
    mapping(address => uint256) public myMap;
    // mapping值只能在函数内部修改
    // strMap[0] = 'zzz'; // 错误

    function getMapItem(address _addr) public view returns (uint256) {
        // 获取对应值  如果 没有设置 则返回默认值
        return myMap[_addr];
    }

    function setMap(address _addr, uint256 _i) public {
        //  更新或设置对应值
        myMap[_addr] = _i;
    }

    function removeMapItem(address _addr) public {
        // 在映射中，删除操作并不会真正移除键值对，而是将值重置为其默认值（对于uint256类型是0）。
        delete myMap[_addr];
    }
    // 嵌套映射
    mapping(address => mapping(uint256 => bool)) public nested;

    function getNested(address _addr1, uint256 _i) public view returns (bool) {
        return nested[_addr1][_i];
    }

    function setNested(address _addr1, uint256 _i, bool _boo) public {
        nested[_addr1][_i] = _boo;
    }

    function removeNested(address _addr1, uint256 _i) public {
        delete nested[_addr1][_i];
    }

    /*
     Array

    */
    uint256[] public arr;
    uint256[] public arr2 = [1, 2, 3];
    // 初始化10位，每位设置对应类型的默认值
    uint256[10] public myFixedSizeArr;
    uint256[] public arr3 = new  uint256[](10);

    function arrayTest() public {
        // arr.push(1);
        // arr.length;
        // arr2[2] = 33;
        arr2.pop();// 删除最后一位
        // delete arr2[0];// 按理说 arr2 => [2,3] 但实际是 [0,2,3]
    }
    // 删除数组执行---- 通过将元素从右向左移动来删除数组元素
    // [1, 2, 3] -- remove(1) --> [1, 3, 3] --> [1, 3]
    // [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
    // [1, 2, 3, 4, 5, 6] -- remove(0) --> [2, 3, 4, 5, 6, 6] --> [2, 3, 4, 5, 6]
    // [1] -- remove(0) --> [1] --> []

    function remove1(uint256 _index) public {
        require(_index < arr.length, "index out of bound");

        for (uint256 i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }

    // arr = [1, 2, 3, 4, 5];
    // delete arr[2];
    // // [1, 2, 4, 5]
    // assert(arr[0] == 1);
    // assert(arr[1] == 2);
    // assert(arr[2] == 4);
    // assert(arr[3] == 5);
    // assert(arr.length == 4);

    // arr = [1];
    // delete arr[0];
    // // []
    // assert(arr.length == 0);

    // 通过将最后一个元素复制到要删除的位置来删除数组元素
    function remove2(uint256 index) public {
        // Move the last element into the place to delete
        arr[index] = arr[arr.length - 1];
        // Remove the last element
        arr.pop();
    }

    // arr = [1, 2, 3, 4];

    // remove(1);
    // // [1, 4, 3]
    // assert(arr.length == 3);
    // assert(arr[0] == 1);
    // assert(arr[1] == 4);
    // assert(arr[2] == 3);

    // remove(2);
    // // [1, 4]
    // assert(arr.length == 2);
    // assert(arr[0] == 1);
    // assert(arr[1] == 4);


    /*
     Enum 枚举
    */
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }
    Status public status;
    // Returns uint
    // Pending  - 0
    // Shipped  - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4
    
    function getStatus() public view returns (Status) {
        return status;
    }

    // 通过同类型值设置
    function setStatus(Status _status) public {
        status = _status;
    }

    // 设置值
    function cancelStatus() public {
        status = Status.Canceled;
    }

    // 重置status为第一个值 0
    function resetStatus() public {
        delete status;
    }

    /*
     struct 结构体
    */
    // 导入了 struct Todo
    // struct Todo {
    //     string text;
    //     bool completed;
    // }
    Todo[] public todos;
    function createTodos(string calldata _text) public {
        // 3 ways to initialize a struct
        // - calling it like a function
        todos.push(Todo(_text, false));

        // key value mapping
        todos.push(Todo({text: _text, completed: false}));

        // initialize an empty struct and then update it
        Todo memory todo;
        todo.text = _text;
        // todo.completed initialized to false

        todos.push(todo);
    }

    // Solidity automatically created a getter for 'todos' so
    // you don't actually need this function.
    function getTodos(uint256 _index)
        public
        view
        returns (string memory text, bool completed)
    {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // update text
    function updateTodosText(uint256 _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    // update completed
    function toggleCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }

    /*
     数据位置
     storage 存储: 变量是一个状态变量（存储在区块链上）
     memory 内存: 变量位于内存中，并且在调用函数时存在
     calldata: 包含函数参数的特殊数据位置  calldata 表示参数是只读的，并且直接从调用者传递过来（不会复制到内存中），因此效率更高。
    */

    // external 是一个外部函数，只能由外部调用。
    // function h(uint256[] calldata _arr) external {
    //     // do something with calldata array
    // }
}
/*
 Transient Storage
 Storage：数据存储在区块链上，永久保存，需要支付 Gas。
 Memory：临时存储，仅在函数调用期间存在，函数调用结束后数据会被清除。
 Transient Storage（暂时存储）：数据仅在一个交易期间有效，交易结束后会被清除。 使用暂时存储可以显著减少 Gas 消耗，因为它不需要永久写入区块链。
*/

// 外部调用 接口用于其他合约与其交互。
interface ITest {
    function val() external view returns (uint256);
    function test() external;
}

contract Callback {
    uint256 public val;
    
    // fallback: 当合约接收到未定义的函数调用时触发。通过
    fallback() external {
        // msg.sender 调用 ITest 接口中的 val() 函数，并将结果存储到 val 中。
        val = ITest(msg.sender).val();
    }

    // test(address target)：调用指定地址合约的 test() 函数。
    function test(address target) external {
        ITest(target).test();
    }
}

contract TestStorage {
    uint256 public val;
    
    function test() public {
        val = 123;
        bytes memory b = "";
        msg.sender.call(b);
    }
}

// Solidity 的 assembly 是一种低级的编程方式，允许开发者直接操作以太坊虚拟机（EVM）的指令，用于优化性能和减少 Gas 消耗

contract TestTransientStorage {
    bytes32 constant SLOT = 0;

    // 通过内联汇编使用 tstore(SLOT, 321) 在暂时存储中写入值。
    function test() public {
        assembly {
            tstore(SLOT, 321)
        }
        bytes memory b = "";
        msg.sender.call(b);
    }

    // 通过内联汇编使用 tload(SLOT) 从暂时存储中读取值。
    function val() public view returns (uint256 v) {
        assembly {
            v := tload(SLOT)
        }
    }
}

contract ReentrancyGuard {
    bool private locked;

    // 使用修饰器 lock() 实现重入保护
    modifier lock() {
        // 如果 locked 为 true，则抛出异常。
        require(!locked);
        // 在函数执行前将 locked 设置为 true，执行完毕后恢复为 false。
        locked = true;
        _;
        locked = false;
    }

    // test()：在重入保护下进行低级调用。
    // 35313 gas
    function test() public lock {
        // Ignore call error
        bytes memory b = "";
        msg.sender.call(b);
    }
}

contract ReentrancyGuardTransient {
    bytes32 constant SLOT = 0;

    modifier lock() {
        // 检查暂时存储中的值，如果为 1，则抛出异常。
        // 在函数执行前将暂时存储位置设置为 1，执行完毕后恢复为 0。
        assembly {
            if tload(SLOT) { revert(0, 0) }
            tstore(SLOT, 1)
        }
        _;
        assembly {
            tstore(SLOT, 0)
        }
    }

    // 21887 gas
    function test() external lock {
        // Ignore call error
        bytes memory b = "";
        msg.sender.call(b);
    }
}

/*
 Error
 Error将撤消在事务期间对状态所做的所有更改。
    
 可调用以下方法抛出错误-----
 require 用于在执行之前验证 Inputs 和 Conditions。
 revert 类似于 require。
 assert 用于检查不应为 false 的代码。断言失败可能意味着存在 bug。
    方法	                    用途	                                 特点
    require	    验证用户输入、前置条件或外部调用返回值是否符合预期。	条件不满足时回滚交易，并退还未消耗的Gas。
    revert	    用于处理复杂逻辑的条件检查。	                    功能与require类似，但更灵活，适合嵌套逻辑。
    assert	    检查内部错误或不变量（永远不应失败的条件）。	       条件失败时回滚交易，但不退还Gas，通常表示合约存在严重问题。
    自定义错误	  提供结构化和高效的错误信息，适用于复杂场景。    	    比字符串消息更节省Gas，并能传递更多上下文信息。
*/

contract Error {
    function testRequire(uint256 _i) public pure {
        // Require should be used to validate conditions such as:
        // - inputs
        // - conditions before execution
        // - return values from calls to other functions
        // 触发后会回滚交易，并退还未消耗的Gas
        require(_i > 10, "Input must be greater than 10");
    }
    // revert更适合用于处理复杂的条件检查。例如，当需要嵌套多个逻辑时，可以使用if + revert结构使代码更清晰。
    function testRevert(uint256 _i) public pure {
        // Revert is useful when the condition to check is complex.
        // This code does the exact same thing as the example above
        // 触发后会回滚交易，并退还未消耗的Gas
        if (_i <= 10) {
            revert("Input must be greater than 10");
        }
    }

    uint256 public num;

    function testAssert() public view {
        // Assert should only be used to test for internal errors,
        // and to check invariants.

        // Here we assert that num is always equal to 0
        // since it is impossible to update the value of num
        // 检查程序中的内部错误或不变量（invariants）。
        // 如果断言失败（即条件不成立），则会触发异常，消耗的Gas不会被退还（Gas不退还是因为这通常表示代码中存在严重的逻辑错误）。
        /*
            适用场景:
            检查那些在正常情况下永远不会失败的条件。
            用于捕捉智能合约中的严重错误或漏洞。
        */
        assert(num == 0);
    }

    // custom error
    // 定义并使用自定义错误来提高错误处理的效率和可读性。
    // 当前合约的余额（balance）。
    // 用户希望提取的金额（withdrawAmount）
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function testCustomError(uint256 _withdrawAmount) public view {
        uint256 bal = address(this).balance;
         // 如果余额不足以满足提取请求，则触发自定义错误，并传递相关参数。
        if (bal < _withdrawAmount) {
            revert InsufficientBalance({
                balance: bal,
                withdrawAmount: _withdrawAmount
            });
        }
    }
}

/*
 管理账户余额。它允许用户存款（deposit）和取款（withdraw）。在每次操作中，合约会检查是否发生溢出（overflow）或下溢（underflow），以确保数据安全。

*/
contract Account {
    uint256 public balance;
    uint256 public constant MAX_UINT = 2 ** 256 - 1;
    // 存款
    function deposit(uint256 _amount) public {
        uint256 oldBalance = balance;
        uint256 newBalance = balance + _amount;

        // balance + _amount does not overflow if balance + _amount >= balance
        // 检查是否发生了溢出（overflow）。如果 newBalance < oldBalance，说明发生了溢出，此时交易会回退
        require(newBalance >= oldBalance, "Overflow");

        balance = newBalance;
        // 再次验证更新后的余额是否大于或等于旧余额，以确保逻辑正确性。
        assert(balance >= oldBalance);
    }
    // 取款
    function withdraw(uint256 _amount) public {
        uint256 oldBalance = balance;

        // balance - _amount does not underflow if balance >= _amount
        // 检查是否发生了下溢（underflow）。如果 balance < _amount，说明余额不足，此时交易会回退
        require(balance >= _amount, "Underflow");
        // 和上面一样效果
        if (balance < _amount) {
            revert("Underflow");
        }

        balance -= _amount;
        // 再次验证更新后的余额是否小于或等于旧余额
        assert(balance <= oldBalance);
    }
    // 在 Solidity 0.8.x 版本中， 默认启用了溢出和下溢检查，因此即使不手动检查，代码本身也会在溢出或下溢时自动抛出错误。
}

/*
 函数修饰符
 修饰符是可以在函数调用之前和/或之后运行的代码。
    修饰符可用于：
        限制访问
        验证输入
        防止重入黑客攻击

onlyOwner: 

*/

contract FunctionModifier {
    // We will use these variables to demonstrate how to use
    // modifiers.
    // 存储合约所有者地址
    address public owner;
    uint256 public x = 10;
    // 用于防止函数的重入攻击
    bool public locked;

    // 在合约部署时运行一次，将部署合约的地址（msg.sender）设置为合约的所有者。
    constructor() {
        // Set the transaction sender as the owner of the contract.
        owner = msg.sender;
    }

    // Modifier to check that the caller is the owner of
    // the contract.
    // 限制只有合约所有者（owner）才能调用标记了该修饰符的函数。
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }

    // Modifiers can take inputs. This modifier checks that the
    // address passed in is not the zero address.
    // 确保传入的地址参数不是零地址（address(0)）。
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }
    // 更改合约的所有者地址。
    function changeOwner(address _newOwner)
        public
        onlyOwner
        validAddress(_newOwner)
    {
        owner = _newOwner;
    }

    // Modifiers can be called before and / or after a function.
    // This modifier prevents a function from being called while
    // it is still executing.
    // 防止函数被重入调用（Reentrancy）。
    modifier noReentrancy() {
        require(!locked, "No reentrancy");

        locked = true;
        _;
        locked = false;
    }
    // 减少变量x的值，并递归调用自己。
    // noReentrancy: 防止重入攻击，确保函数在递归调用时不会被再次进入。
    function decrement(uint256 i) public noReentrancy {
        x -= i;

        if (i > 1) {
            decrement(i - 1);
        }
    }
}

/*
 Events 事件
 允许记录到 Ethereum 区块链。事件的一些用例包括：
    侦听事件和更新用户界面
    一种廉价的存储形式
-- 是Solidity中的一种特殊结构，用于在以太坊区块链上记录日志。事件允许智能合约将数据写入交易日志，这些日志可以在链外（例如前端应用程序）被监听和处理。
*/

contract Event {
    // Event declaration
    // Up to 3 parameters can be indexed.
    // Indexed parameters helps you filter the logs by the indexed parameter

    // address indexed sender: 表示发送方的地址，并且被标记为indexed，允许在日志中按此字段进行过滤和查询。
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}

/*
 构造函数
 是在创建合约时执行的可选函数。

 Solidity 中，无论子合约的构造函数中以何种顺序调用父合约的构造函数，父合约的构造函数总是按照继承声明的顺序被调用。
*/

contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

// Base contract Y
contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// There are 2 ways to initialize parent contract with parameters.

// Pass the parameters here in the inheritance list.
// 集成XY ，并传递参数初始化XY参数
contract B is X("Input to X"), Y("Input to Y") {}

// 在其构造函数中显式调用父合约的构造函数 (X(_name) 和 Y(_text)) 来传递参数。
contract C is X, Y {
    // Pass the parameters here in the constructor,
    // similar to function modifiers.
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

// Parent constructors are always called in the order of inheritance
// regardless of the order of parent contracts listed in the
// constructor of the child contract.

// Order of constructors called: 构造函数调用顺序 按照  contract D is " X, Y " 声明的顺序
// 1. X
// 2. Y
// 3. D
contract D is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}

// Order of constructors called:
// 1. X
// 2. Y
// 3. E
contract E is X, Y {
    constructor() Y("Y was called") X("X was called") {}
}