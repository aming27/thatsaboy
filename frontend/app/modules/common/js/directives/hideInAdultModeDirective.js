(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('hideInAdultMode', showInAdultMode);

  showInAdultMode.$inject = ['loginService'];

  function showInAdultMode(loginService) {
    return {
      restrict: 'A',
      link    : function ($scope, element, attrs, ctrl) {
        $scope.$watch(function(){
          return loginService.isAdultMode();
        }, function(isAdultMode){
          if(isAdultMode == false){
              element[0].classList.remove('ng-hide');
          } else {
              element[0].classList.add('ng-hide');
          }
        })
      }
    };
  }
})();