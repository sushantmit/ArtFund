pragma solidity ^0.4.16;

import "./ArtBase.sol";

contract ArtCore is ArtBase {

	function getProject(uint256 _projectId)
        external
        view
        returns (
        address _creator,
        string _title,
        string _description,
        uint256 _startedAt,
        uint256 _expiry,
        uint256 _goal
        bool _isOpen
    ) {
        Project storage project = projects[_projectId];

        _creator = uint256(project.creator);
        _title = uint256(project.title);
        _description = uint256(project.description);
        _startedAt = uint256(project.startedAt);
        _duration = uint256(project.duration);
        _goal = uint256(project.goal);
        _isOpen = isActive(project);

    }

}
