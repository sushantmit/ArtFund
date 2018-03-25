pragma solidity ^0.4.16;

contract ArtBase {

    struct Project {

        //Creator of project
        address creator;
        //Title Project
        string title;
        //Description
        string description;
        //timestamp of posting
        uint256 startedAt;
        //expiry time to stop funding;
        uint256 expiry;
        //Funding Goal
        uint256 goal;
    }


    //Array to hold all created projects
    Project[] projects;
    mapping(uint256 => uint256) projectToValue; //project id to funding achieved mapping

    event ProjectCreated(uint256 projectId, uint256 fundGoal, uint64 startedAt);
    event ProjectClosed(uint256 projectId, uint256 finalFund, uint64 closedAt);
    event ContributionMade(uint256 projectId, uint256 fundAmount, address funder);



    //function _addProject(uint256 _projectId, Project _project) internal {

        // Add Project to projectToValue mapping data structure
      //  projectToValue[_project] = 0;
        // Fire Project created event
      //  ProjectCreated(_projectId, _project.goal, _project.startedAt);
    //}


    function isActive(Project storage _project) public view returns (bool) {
        return (now < _project.expiry);
    }

    // Function to create a Project for funding
    function createProject(string _title, string _description, uint256 _duration, uint256 _goal)
    public returns (uint) {

        // Creation of the Project
        Project memory _project = Project({
          creator: msg.sender,
          title: _title,
          description: _description,
          startedAt: now,
          expiry: now + _duration,
          goal: _goal,
          });

        uint256 newProjectId = projects.push(_project) - 1;

        // Add Project to projectToValue mapping data structure
        projectToValue[_newProjectId] = 0;
        // Fire Project created event
        ProjectCreated(_newProjectId, _project.goal, _project.startedAt);
    }

    // Function that handles the bid internally
    function _contri(uint256 _projectId, uint256 _contriAmount) internal {

        // Get the Project for this projectId
        Project storage project = projects[_projectId];
        // Check if Funding is still Active
        require(isActive(project));

        // Get seller before deleting the sale struct
        address projectCreator = project.creator;

        // Transfer the proceeds to creator
        projectCreator.transfer(_contriAmount);

        // Project current fund increased
        projectToValue[_projectId] += _contriAmount;
    }

    // Function to contribute to the project
    function contribute(uint256 _projectId) external payable {
        address creator = projects[_projectId].creator;
        _contri(_projectId, msg.value);
        ContributionMade(_projectId, msg.value, msg.sender);
    }

}
