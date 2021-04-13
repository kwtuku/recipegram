document.addEventListener('DOMContentLoaded', function() {
  var nodelist = document.querySelectorAll('.dropdown-trigger');
  var elements = Array.prototype.slice.call(nodelist, 0);

  elements.forEach(function(element) {
    var button = element.querySelector('button');
    var dropdown = element.parentNode;

    button.addEventListener('click', function() {
      dropdown.classList.add('is-active');
    });
  });
});
