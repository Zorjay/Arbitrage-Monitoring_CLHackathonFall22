// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


contract ArbitrageMonitoring is Ownable{
    using SafeMath for uint256;

    struct Pool {
        address routerAddress;
        IUniswapV2Router02 router;
        address tokenA;
        address tokenB;
        address pairAddress;
        IUniswapV2Pair pair;
    }

    struct ArbitrageOpportunity {
        address router0;
        address router1;
        address tokenA;
        address tokenB;
        uint256 priceBofARouter0;
        uint256 priceBofARouter1;
        uint256 delta;
    }

    Pool[] public liquidityPools;

    constructor(){}

    
    function lpPresent(address _router, address _tokenA, address _tokenB) public view returns(bool){
        for (uint i=0; i<liquidityPools.length; i++){
            if (liquidityPools[i].routerAddress == _router && 
               ((liquidityPools[i].tokenA == _tokenA && liquidityPools[i].tokenB == _tokenB) || (liquidityPools[i].tokenA == _tokenB && liquidityPools[i].tokenB == _tokenA))
               ) {
                return true;
            }
        }
        return false;
    }
    
    function addLiquidityPool(address _newRouter, address _tokenA, address _tokenB) external onlyOwner {
        require(!lpPresent(_newRouter, _tokenA, _tokenB), "Liquidity pool is already being monitored");

        Pool memory newPool;
        newPool.routerAddress = _newRouter;
        newPool.router = IUniswapV2Router02(_newRouter);
        newPool.tokenA = _tokenA;
        newPool.tokenB = _tokenB;

        address _newPair = IUniswapV2Factory(newPool.router.factory()).getPair(address(_tokenA), address(_tokenB));

        newPool.pairAddress = _newPair;
        newPool.pair = IUniswapV2Pair(_newPair);

        liquidityPools.push(newPool);
    }

    function removeLiquidityPool(address _oldRouter, address _oldTokenA, address _oldTokenB) external onlyOwner {
        require(lpPresent(_oldRouter, _oldTokenA, _oldTokenB), "Liquidity pool is not being monitored");

        for (uint i=0; i<liquidityPools.length; i++) {
            if (liquidityPools[i].routerAddress == _oldRouter && 
               ((liquidityPools[i].tokenA == _oldTokenA && liquidityPools[i].tokenB == _oldTokenB) || (liquidityPools[i].tokenA == _oldTokenB && liquidityPools[i].tokenB == _oldTokenA))
               ) {
                liquidityPools[i] = liquidityPools[liquidityPools.length -1];
                liquidityPools.pop();
            }
        }

    }

    function getNumRoutersForPair(address _tokenA, address _tokenB) internal view returns(uint) {
        uint numRouters = 0;
        for (uint i=0; i<liquidityPools.length; i++) {
            if ((liquidityPools[i].tokenA == _tokenA && liquidityPools[i].tokenB == _tokenB) || (liquidityPools[i].tokenA == _tokenB && liquidityPools[i].tokenB == _tokenA)) {
                numRouters = numRouters + 1;
            }
        }
        return numRouters;
    }

    function getPriceBOfA(address _tokenA, address _tokenB) public view returns(address[] memory, uint256[] memory){
        uint numberOfRouters = getNumRoutersForPair(_tokenA, _tokenB);

        require(numberOfRouters>0, "Pair not monitored");

        address[] memory routersAddress = new address[](numberOfRouters);
        uint256[] memory amountBs = new uint256[](numberOfRouters);

        uint currentRouter = 0;

        for (uint i=0; i<liquidityPools.length; i++) {
            if (liquidityPools[i].tokenA == _tokenA && liquidityPools[i].tokenB == _tokenB) {
                uint reserveA;
                uint reserveB;
                (uint112 reserve0, uint112 reserve1, ) = liquidityPools[i].pair.getReserves();
                if (liquidityPools[i].pair.token0() == _tokenA) {
                    reserveA = uint(reserve0);
                    reserveB = uint(reserve1);
                } else {
                    reserveA = uint(reserve1);
                    reserveB = uint(reserve0);
                }
                uint8 decimals = IERC20Metadata(_tokenA).decimals();
                uint amountB = liquidityPools[i].router.quote(uint(10**decimals), reserveA, reserveB);

                routersAddress[currentRouter] = liquidityPools[i].routerAddress;
                amountBs[currentRouter] = amountB;
                currentRouter = currentRouter + 1;

            } else if (liquidityPools[i].tokenA == _tokenB && liquidityPools[i].tokenB == _tokenA) {
                uint reserveA;
                uint reserveB;
                (uint112 reserve0, uint112 reserve1, ) = liquidityPools[i].pair.getReserves();
                if (liquidityPools[i].pair.token0() == _tokenA) {
                    reserveA = uint(reserve0);
                    reserveB = uint(reserve1);
                } else {
                    reserveA = uint(reserve1);
                    reserveB = uint(reserve0);
                }
                uint8 decimals = IERC20Metadata(_tokenA).decimals();
                uint amountB = liquidityPools[i].router.quote(uint(10**decimals), reserveB, reserveA);

                routersAddress[currentRouter] = liquidityPools[i].routerAddress;
                amountBs[currentRouter] = amountB;
                currentRouter = currentRouter + 1;
            }
        }

        return (routersAddress, amountBs);
    }

    function getPairAddress(address _router, address _tokenA, address _tokenB) public view returns(address) {
        require(lpPresent(_router, _tokenA, _tokenB), "Liquidity pool is not being monitored");

        for (uint i=0; i<liquidityPools.length; i++) {
            if (liquidityPools[i].routerAddress == _router && 
               ((liquidityPools[i].tokenA == _tokenA && liquidityPools[i].tokenB == _tokenB) || (liquidityPools[i].tokenA == _tokenB && liquidityPools[i].tokenB == _tokenA))
               ) {
                   return liquidityPools[i].pairAddress;
            }
        }

        return address(0);
    }

    function isArbitrage(address _tokenA, address _tokenB) public view returns(ArbitrageOpportunity memory) {
        uint numberOfRouters = getNumRoutersForPair(_tokenA, _tokenB);
        require(numberOfRouters>1, "Pair not monitored from different routers");

        uint256 maxDelta = 0;
        address router0 = address(0);
        address router1 = address(0);
        uint256 priceBofARouter0;
        uint256 priceBofARouter1;

        ArbitrageOpportunity memory ab;
        ab.tokenA = _tokenA;
        ab.tokenB = _tokenB;
        
        (address[] memory routers, uint256[] memory prices) = getPriceBOfA(_tokenA, _tokenB);
        
        for (uint i=0; i<prices.length; i++){
            for (uint j=i+1; j<prices.length; j++){
                if (prices[i] > prices[j]) {
                    if (prices[i] - prices[j] > maxDelta) {
                        maxDelta = prices[i] - prices[j];
                        router0 = routers[i];
                        router1 = routers[j];
                        priceBofARouter0 = prices[i];
                        priceBofARouter1 = prices[j];
                    }
                } else {
                    if (prices[j] - prices[i] > maxDelta) {
                        maxDelta = prices[j] - prices[i];
                        router0 = routers[i];
                        router1 = routers[j];
                        priceBofARouter0 = prices[i];
                        priceBofARouter1 = prices[j];
                    }
                }
            }
        }
        
        ab.router0 = router0;
        ab.router1 = router1;
        ab.priceBofARouter0 = priceBofARouter0;
        ab.priceBofARouter1 = priceBofARouter1;
        ab.delta = maxDelta;

        return ab;
    }

}
