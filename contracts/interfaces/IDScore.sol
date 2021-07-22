// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDScore {
    event MembershipStaked(address member, uint256 amountStaked);

    event DScoreIncreased(
        address member,
        uint256 factor,
        uint256 amountIncreased
    );

    event DScoreDecreased(
        address member,
        uint256 factor,
        uint256 amountDecreased
    );

    event Memberfrozen(address member, uint256 timeFrozen);

    /**
  @notice stakeMembership allows a user to stake DecentraStock in-order to become a Decentracorp member
  @param _stakeAmount is the amount of DecentraStock being staked on the users membership
  */
    function stakeMembership(uint256 _stakeAmount) external;

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

          @dev some of these factors are increased in ways other than this function such as #2 for votes
  */
    function increaseDScore(
        address _member,
        uint256 _factor,
        uint256 _amount
    ) external;

    /**
  @notice increaseDScore is a protected function that allows approved DecentraCorp contracts to decrease a users D-Score
  @param _member is the address of the member who's D-Score is being decrease
  @param _factor is the number representing which factor of the users D-Score is being decrease
  @param _amount is the amount the user's D-Score is being decrease by
  */
    function decreaseDScore(
        address _member,
        uint256 _factor,
        uint256 _amount
    ) external;

    /**
  @notice calculateVotingPower is used to calculate a members current voting power relative to their D-Score
  @param _member is the address of the member who's voting power is being retreived
  */
    function calculateVotingPower(address _member)
        external
        view
        returns (uint256);

        /**
        @notice checkStaked is a view only function to easily check if an account is a staked member
        @param _member is the address in question
        @dev this function returns a bool for "yes staked" or "not staked". This function does NOT return
              the amount a member has staked
        */
        function checkStaked(address _member) external view returns(bool);
}
