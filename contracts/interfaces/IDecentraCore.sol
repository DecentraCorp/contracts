// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDecentraCore {
    event NewProposal(
        uint256 proposalId,
        uint256 proposalAmount,
        address target,
        bytes call_data
    );

    event NewVote(uint256 proposalId, address voter, bool vote);

    event ProposalApproved(uint256 proposalId, bool success);

    //  event NewApprovedContract(address, contract);

    event FunctionCallDelegated(address target, bytes call_data);

    /**
  @notice transferxDAI is used to easily transfer xDAI from the DecentraCorp contract
  @param _to is the address tokens are being minted to
  @param _amount is the amount of tokens being minted
  @dev this function is intended to be used with the proposal system
  **/
    function transferxDAI(address payable _to, uint256 _amount) external;

    /**
  @notice newProposaln allows a user to create a proposal
  @param _target is the address this proposal is targeting
  @param _proposalHash is an IPFS hash of a file representing a proposal
  @param _calldata is a bytes representation of a function call
  **/
    function newProposal(
        address payable _target,
        string memory _proposalHash,
        bytes memory _calldata
    ) external payable returns (uint256);

    /**
  @notice setQuorum allows the owner of the DAO(normally set as the the DAO itself) to change
          the quorum used in voting
  @notice _quorum is the input quarum number being set
  **/
    function setQuorum(uint256 _quorum) external;

    /**
  @notice the vote function allows a DAO member to vote on proposals made to the DAO
  @param _ProposalID is the number ID associated with the particular proposal the user wishes to vote on
  @param  supportsProposal is a bool value(true or false) representing whether or not a member supports a proposal
                  -true if they do support the proposal
                  -false if they do not support the proposal
  @dev this function will trigger the _checkThreshold function which determines if enough members have voted to
            fire the executeProposal function.(this is temporarily removed due to what im assuming are the gas block limit)
  **/
    function vote(uint256 _ProposalID, bool supportsProposal) external;

    /**
  @notice setApprovedContract is a protected function that allows a successful proposal to grant
          privledges to DecentraCorp contracts
  @param _contract is the address of the contract being approved
  @param _privledge is a number representing which privledge is being set
  @dev privledges:
                  1. Minting
                  2. Burning
                  3. D-Score
  */
    function setApprovedContract(address _contract, uint256 _privledge)
        external;

    /**
  @notice freezeMember is a protected function used to allow for a DecentraCorp contract to freeze an account
          in the case of suspected fraud
  @param _member is the address of the member who is being frozen
  @dev this function is intended to be called by the audit contracts of phase two and will not play an active role in phase one
  @dev this function can also be used to un-freeze an account
  */
    function freezeMember(address _member) external;

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

    /**
  @notice dScoreMod is used to allow other contracts to call the dScoreMod mapping
  @param _add is the address in question
  */
    function dScoreMod(address _add) external returns (bool);

    /**
  @notice getProposal is used to retrieve proposal data
  @param _id is the id of the proposal being retrieved
  */
    function getProposal(uint256 _id)
        external
        view
        returns (
            address maker,
            address target,
            uint256 voteWeights,
            uint256 voteID,
            uint256 timeCreated,
            bool executed,
            string memory proposalHash,
            bytes memory call_data
        );
}
