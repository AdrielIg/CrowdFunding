// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    enum State {
        Open,
        Closed
    }

    struct Contribution {
        address contributor;
        uint256 value;
    }

    struct Project {
        string id;
        address payable owner;
        uint256 fundraisingGoal;
        uint256 funds;
        string name;
        State state;
        string description;
    }

    Project[] public projects;
    //Project name => Array of structs "Contribution"
    mapping(string => Contribution[]) public contributions;

    event FundProject(uint256 value, uint256 funds, string name);
    event ChangeState(State newState, string name);
    event ProjectCreated(
        string name,
        string description,
        uint256 fundraisingGoal
    );

    modifier onlyOwner(uint256 projectIndex) {
        require(
            projects[projectIndex].owner == msg.sender,
            "Only the owner can call this function"
        );
        _;
    }
    modifier notOwner(uint256 projectIndex) {
        require(
            projects[projectIndex].owner == msg.sender,
            "All but owner can call this function"
        );
        _;
    }

    function createProject(
        string calldata _id,
        string calldata _name,
        string calldata _description,
        uint256 _fundraisingGoal
    ) public {
        require(_fundraisingGoal > 0, "FundraisingGoal must be greater than 0");
        Project memory project = Project(
            _id,
            payable(msg.sender),
            _fundraisingGoal,
            0,
            _name,
            State.Open,
            _description
        );
        projects.push(project);
        emit ProjectCreated(_name, _description, _fundraisingGoal);
    }

    function fundProject(uint256 projectIndex)
        public
        payable
        notOwner(projectIndex)
    {
        Project memory project = projects[projectIndex];
        require(
            project.state != State.Closed,
            "The project can't receive funds"
        );
        require(msg.value > 0, "The value must be greater than 0");
        project.owner.transfer(msg.value);
        project.funds += msg.value;

        contributions[project.id].push(Contribution(msg.sender, msg.value));

        emit FundProject(msg.value, project.funds, project.name);
    }

    function changeProjectState(State _newState, uint256 projectIndex)
        public
        onlyOwner(projectIndex)
    {
        Project memory project = projects[projectIndex];
        require(
            project.state != _newState,
            "New state must be different than the actual"
        );
        project.state = _newState;
        emit ChangeState(_newState, project.name);
    }
}
