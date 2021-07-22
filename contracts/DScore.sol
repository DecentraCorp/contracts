pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/IDecentraCore.sol";
import "./interfaces/IDecentraStock.sol";


////////////////////////////////////////////////////////////////////////////////////////////
/// @title DecentraCore
/// @author Christopher Dixon
////////////////////////////////////////////////////////////////////////////////////////////
/**
The Cortex contract is designed to be a bare bones, minimalistic approach to a versitile DAO structure. The Cortex is designed as
    the control center that Allows a DAO to work with neuron contracts and contracts outside of the zer0 ecosystem.
**/

contract DecentraCore is Ownable {
    using SafeMath for uint256;

    ///stakedCounter is a tracker for the total number of DecentraStock staked
    uint256 public stakedCounter;

    /// @notice ds is the DecentraStock contract
    IDecentraStock public ds;
    /// @notice ds is the DecentraCore contract
    IDecentraCore public dc;

    ///@notice members tracks a members D-Score to their address
    mapping(address => DScore) public members;

    /**
    @notice the modifier onlyMember requires that the function caller must be a member of the DAO to call a function
    @dev this requires the caller to have atleast 1e18 of a token(standard 1 for ERC20's)
    **/
    modifier onlyDSmod() {
        require(
            dc.dScoreMod(msg.sender),
            "DecentraCore: Caller is not a DScore MOD"
        );
        _;
    }


    /**
    @notice DScore is a struct used to store a Decentracorp members D-Score parameters
    @param level is a members level that is determined by the DecentraCorp community as a way of rewarding members for non
        D-job related tasks such as a technical task, community service, or other work related reward.
    @param jobs is the number of completed jobs done by the member.
    @param votes is the number of DecentraCorp votes the member has participated in.
    @param reputation is the overall average of the rating of each job performed.
    @param staked is the number of DercentraStock a member has staked
    @param verified is the number of times this member has been audited by other members
    @param audit is the number of other members this account has audited
    */
    struct DScore {
      uint256 level;
      uint256 jobs;
      uint256 votes;
      uint256 reputation;
      uint256 staked;
      uint267 verified;
      uint256 audit;
    }


    /**
    @notice stakeMembership allows a user to stake DecentraStock in-order to become a Decentracorp member
    @param _stakeAmount is the amount of DecentraStock being staked on the users membership
    */
    function stakeMembership(uint256 _stakeAmount) external {
              dc.proxyBurnDS(msg.sender, _stakeAmount);
              DScore storage dscore = members[msg.sender];
              dscore.staked = dscore.staked.add(_stakeAmount);
              emit MembershipStaked(msg.sender, _stakeAmount);
    }

    /**
    @notice increaseDScore is a protected function that allows approved DecentraCorp contracts to increase a users D-Score
    @param _member is the address of the member who's D-Score is being increased
    @param _factor is the number representing which factor of the users D-Score is being increased
    @param _amount is the amount the user's D-Score is being increased by
    @dev D-Score factors are represented by a number within a mapping. The key for this mapping is as follows:

            0 - Level: a members level is determined by the DecentraCorp community as a way of rewarding members for non
                D-job related tasks such as a technical task, community service, or other work related reward.
            1 - Jobs: the number of completed jobs done by the member.
            2 - Votes: the number of DecentraCorp votes the member has participated in.
            3 - Reputation: the overall average of the rating of each job performed.
            4 - Staked: the number of DercentraStock a member has staked
            5 - Verified: number of times this member has been audited by other members
            6 - Audit: number of other members this account has audited
    */
    function increaseDScore(address _member, uint256 _factor, uint256 _amount) public onlyDSmod {
              require(_factor < 7, "D-Score: Invalid factor")
              DScore storage dscore = members[msg.sender];
              if(_factor == 0){
                dscore.level = dscore.level.add(_amount);
              }
              if(_factor == 1){
                dscore.jobs = dscore.jobs.add(_amount);
              }
              if(_factor == 2){
                dscore.votes = dscore.votes.add(_amount);
              }
              if(_factor == 3){
                dscore.reputation = dscore.reputation.add(_amount);
              }
              if(_factor == 4){
                  dscore.staked = dscore.staked.add(_amount);
              }
              if(_factor == 5){
                dscore.verified = dscore.verified.add(_amount);
              }
              if(_factor == 6){
                dscore.audit = dscore.audit.add(_amount);
              }
              emit DScoreIncreased(_member, _factor, _amount);
    }

    /**
    @notice increaseDScore is a protected function that allows approved DecentraCorp contracts to decrease a users D-Score
    @param _member is the address of the member who's D-Score is being decrease
    @param _factor is the number representing which factor of the users D-Score is being decrease
    @param _amount is the amount the user's D-Score is being decrease by
    */
    function decreaseDScore(address _member, uint256 _factor, uint256 _amount) public onlyDSmod {
      require(_factor < 7, "D-Score: Invalid factor")
      DScore storage dscore = members[msg.sender];
      if(_factor == 0){
        dscore.level = dscore.level.sub(_amount);
      }
      if(_factor == 1){
        dscore.jobs = dscore.jobs.sub(_amount);
      }
      if(_factor == 2){
        dscore.votes = dscore.votes.sub(_amount);
      }
      if(_factor == 3){
        dscore.reputation = dscore.reputation.sub(_amount);
      }
      if(_factor == 4){
          dscore.staked = dscore.staked.sub(_amount);
      }
      if(_factor == 5){
        dscore.verified = dscore.verified.sub(_amount);
      }
      if(_factor == 6){
        dscore.audit = dscore.audit.sub(_amount);
      }
      emit DScoreDecreased(_member, _factor, _amount);
    }


    /**
    @notice calculateVotingPower is used to calculate a members current voting power relative to their D-Score
    @param _member is the address of the member who's voting power is being retreived
    */
    function calculateVotingPower(address _member) external view returns(uint256);

    /**
    @notice checkStaked is a view only function to easily check if an account is a staked member
    @param _member is the address in question
    @dev this function returns a bool for "yes staked" or "not staked". This function does NOT return
          the amount a member has staked
    */
    function checkStaked(address _member) external view returns(bool);
}
