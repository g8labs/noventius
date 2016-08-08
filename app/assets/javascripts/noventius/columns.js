(function(){

  function getSorterForType(type) {
    switch(type) {
      case 'datetime':
      case 'date':
        return 'date';
        break;
      case 'integer':
      case 'float':
        return 'digit';
        break;
      default:
        return 'text';
    }
  }

  function addColumnsSorting(table) {
    var $this = $(table);

    var headers = $this.find('th').map(function(index, element) {
      var $element = $(element);
      var sorter;

      if ($element.hasClass('column-header')) {
        var type = $element.data('type');
        sorter = getSorterForType(type);
      } else {
        sorter = false;
      }

      return { sorter: sorter };
    });

    $this.tablesorter({
      theme: 'bootstrap',
      widthFixed: true,
      headerTemplate: '{content} {icon}',
      widgets: ['uitheme'],
      headers: headers
    });
  }

  $(function() {
    $.tablesorter.addParser({
      id: 'date',
      is: function(s) {
        return false;
      },
      format: function(datetime) {
        return moment(datetime).utc().format('x');
      },
      type: 'numeric'
    });

    $('table').each(function() {
      addColumnsSorting(this);
    });
  });

})();
