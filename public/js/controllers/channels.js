function channelListCtrl ($scope, ChannelApi, $cookieStore, $route) {

	ChannelApi.channels.customGETLIST("", {'auth_token': $cookieStore.get("auth_token")}).then(function (response) {
		 $scope.channels = response;
	});
	
	$scope.getPublicChannels = function () {
		ChannelApi.public_channels.customGETLIST("", {'auth_token': $cookieStore.get("auth_token")}).then(function (response) {
			 $scope.channels = response;
		});
	}
	
	$scope.getPrivateChannels = function () {
		ChannelApi.private_channels.customGETLIST("", {'auth_token': $cookieStore.get("auth_token")}).then(function (response) {
			 $scope.channels = response;
		});
	}
	
	
}

function channelDetailsCtrl($scope, $routeParams, ChannelApi) {
	if($routeParams.channelId != null){
		ChannelApi.channel.one($routeParams.channelId).get().then(function (response) {
			$scope.channel = response; 
		});
		
		/*ChannelApi.channel.one($routeParams.channelId).get().then(function (response) {
			$scope.channel = response; 
		});*/
	}
	
	$scope.getChannelPrograms = function (cid) {
		ChannelApi.channel_programs.one(cid).get().then(function (response) {
			$scope.channelPrograms = response; 
		});
	}
	
}