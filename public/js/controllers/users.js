/**
 * user registration
 * @param $scope
 * @param $location
 * @param DataService
 */
function signupCtrl ($scope, $location, DataService) {
	$scope.create = function () {
		DataService.users.post($scope.User).then(function(){
			$location.path('/home');
		});
	}
}

function loginCtrl ($scope, $location, DataService) {
	$scope.login = function () {
		DataService.user_login.post($scope.User).then(function (){
			$location.path('/home');
		});
	}
}

function userListCtrl ($scope, DataService) {
	$scope.users = DataService.users.getList();
}
