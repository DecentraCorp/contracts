//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


interface IDecentraCore {

  event NewProposal(uint256 proposalId, uint256 proposalAmount, address target, bytes call_data);

  event NewVote(uint256 proposalId, address voter, bool vote);

  event ProposalApproved(uint256 proposalId, bool success);

  event NewApprovedContract(address contract);

  event FunctionCallDelegated(address target, uint256 amount, bytes call_data);

  event MembershipStaked(address member, uint256 amountStaked);

  event DScoreIncreased(address member, uint256 factor, uint256 amountIncreased);

  event DScoreDecreased(address member, uint256 factor, uint256 amountDecreased);

  /**
  @notice submitProposal allows a user to submit a proposal to DecentraCorp
  @param _proposalAmount is an optional value amount taht can be added to a proposal
  @param _target is the address of the target of the proposal
  @param call_data is the packaged function call that will be fired if this proposal is successful
  */
  function submitProposal(uint256 _proposalAmount, address _target, bytes call_data) external returns(uint256);

  /**
  @notice vote allows DecentraCorp members to vote on a proposal
  @param _proposalId is the ID of the proposal being voted on
  @param _vote a bool representing the users vote(yes = true / no = false)
  */
  function vote(uint256 _proposalId, bool _vote) external;

  /**
  @notice delegateFunctionCall is a protected function that allows the DecentraCorp contract
          to make arbitrary calls to other contracts
  @param _target is the address of the target of the call
  @param _amount is a value amount associated with the call
  @param call_data is the packaged function call that will be fired if this proposal is successful
  */
  function delegateFunctionCall(
    address payable _target,
    uint256 _amount,
    bytes memory call_data
  ) external;


  /**
  @notice setApprovedContract is a protected function that allows a successful proposal to grant DecentraDollar
          minting privledges to DecentraCorp contract
  @param _contract is the address of the contract being approved
  */
  function setApprovedContract(address _contract) external;

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
  function increaseDScore(address _member, uint256 _factor, uint256 _amount) external;

  /**
  @notice increaseDScore is a protected function that allows approved DecentraCorp contracts to decrease a users D-Score
  @param _member is the address of the member who's D-Score is being decrease
  @param _factor is the number representing which factor of the users D-Score is being decrease
  @param _amount is the amount the user's D-Score is being decrease by
  */
  function decreaseDScore(address _member, uint256 _factor, uint256 _amount) external;

  /**
  @notice freezeMember is a protected function used to allow for a DecentraCorp contract to freeze an accounts
          Decentracorp fininces in the case of suspected fraud
  @param _member is the address of the member who is being frozen
  @dev this function is intended to be called by the audit contracts of phase two and will not play an active role in phase one
  */
  function freezeMember(address _member) external;

  /**
  @notice calculateVotingPower is used to calculate a members current voting power relative to their D-Score
  @param _member is the address of the member who's voting power is being retreived
  */
  function calculateVotingPower(address _member) external view returns(uint256);

  /**
  @notice proxyMintDD is a protected function that allows an approved contract to mint DecentraDollar
  @param _to is the address the DecentraDollar is being minted to
  @param _amount is the amount being minted
  */
  function proxyMintDD(address _to, uint256 _amount) external;

  /**
  @notice proxyMintDS is a protected function that allows an approved contract to issue DecentraStock
  @param _to is the address the DecentraStock is being issued to
  @param _amount is the amount being issued
  */
  function proxyMintDS(address _to, uint256 _amount) external;

  /**
  @notice proxyBurnDD is a protected function that allows an approved contract to burn DecentraDollar
  @param _from is the address the DecentraDollar is being burned from
  @param _amount is the amount being burned
  */
  function proxyBurnDD(address _from, uint256 _amount) external;

  /**
  @notice proxyBurnDS is a protected function that allows an approved contract to burn DecentraStock
  @param _from is the address the DecentraStock is being burned from
  @param _amount is the amount being burned
  */
  function proxyBurnDS(address _from, uint256 _amount) external;
}
