function friendsListCtrl ($scope, FriendApi, $cookieStore) {
	$scope.friends = FriendApi.friends.customGETLIST("", {'auth_token': $cookieStore.get("auth_token")});
}

function FriendshipRequestListCtrl ($scope, FriendApi, $cookieStore, $location) {
	$scope.friends = FriendApi.friend_request.customGET("", {'auth_token': $cookieStore.get('auth_token')})
	$scope.approveRequest = function (user_id) {
		FriendApi.friend.customPOST("", {'auth_token': $cookieStore.get('auth_token')}, "",{'friend_id': user_id}).then(function (response) {
			$location.path('/my_friends');
		});
	}
}