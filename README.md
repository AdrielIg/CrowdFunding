# Crowd Funding Contract

### Functions:

#### **createProject**

function createProject(string calldata \_id, string calldata \_name,string calldata \_description,uint256 \_fundraisingGoal);

Creates a project that it will be saved in a array with it respective **index**

#### **fundProject**

function fundProject(uint256 projectIndex) public payable notOwner(projectIndex);

With this function you can fund the project you want, you only need its index to access that project. Everyone but the owner can fund the project

#### **changeProjectState**

function changeProjectState(State \_newState, uint256 projectIndex) public onlyOwner (projectIndex);

And lastly with this one only the owner of the project can change the state between _Opened_ or _Closed_
