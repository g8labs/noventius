(function(){

  $(function() {
    $('table').on('click', 'tr[data-nested]', function() {
      var $this = $(this);
      var nested = $this.data('nested');

      if ($this.next('tr.nested-container').length) {
        $this.siblings('tr.nested-container').remove();
        return;
      }

      var td = $('<td>').attr('colspan', $this.find('td').length);
      var tr = $('<tr>').append(td).addClass('nested-container');

      $this.siblings('tr.nested-container').remove();

      $this.after(tr);

      var data = nested.filters;
      data.row = nested.row;
      $.get(nested.url, data, function(table) {
        td.append(table);
        addColumnsSorting(td.find('table'));
      });
    });
  });

})();
