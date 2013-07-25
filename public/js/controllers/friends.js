function friendsListCtrl ($scope, FriendApi, $cookieStore, $location, $window, $route) {
	FriendApi.friends.customGETLIST("", {'auth_token': $cookieStore.get("auth_token")}).then(function (response) {
		 $scope.friends = response;
	});
	
	$scope.unFriend = function (friendship_id) {
		FriendApi.friends.customDELETE(friendship_id, {'auth_token': $cookieStore.get("auth_token")}).then(function (response) {
			$route.reload();
		});
	}
}

function FriendshipRequestListCtrl ($scope, FriendApi, $cookieStore, $location) {
	FriendApi.friend_request.customGET("", {'auth_token': $cookieStore.get('auth_token')}).then(function (response) {
		$scope.friendRequests = response;
	});
	
	$scope.approveRequest = function (user_id) {
		FriendApi.friend.customPOST("", {'auth_token': $cookieStore.get('auth_token')}, "",{'friend_id': user_id}).then(function (response) {
			$location.path('/my_friends');
		});
	}
	
	$scope.ignoreRequest = function (friendship_request_id) {
		FriendApi.friend_request.customDELETE(friendship_request_id, {'auth_token': $cookieStore.get('auth_token')}, "").then(function (response) {
			$location.path('/my_friends');
		});
	} 
}