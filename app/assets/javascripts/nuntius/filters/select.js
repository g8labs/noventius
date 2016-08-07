(function(){
  function dependencyValue(dependency) {

    return $('select.nuntius-filter#q_' + dependency).val();
  }

  function handleSelectChange(filter, clear) {
    var filterId = $(filter).attr('id').replace('q_', '');

    $('select.nuntius-filter').each(function() {
      var $this = $(this);
      var dependentFilters = $this.data('dependent') || [];

      if (!Array.isArray(dependentFilters)) {
        dependentFilters = [dependentFilters];
      }

      if (dependentFilters.includes(filterId)) {
        if (clear) {
          clearDependentSelect($this);
        } else {
          updateDependentSelect($this, dependentFilters);
        }
      }
    });
  }

  function clearDependentSelect($filter) {
    $filter.html('').select2({data: null});
    $filter.prop('disabled', true);
    handleSelectChange($filter, true);
  }

  function updateDependentSelect($filter, dependencies) {
    var values = dependencies.map(dependencyValue);
    var options = $filter.data('options')[values.join('_!_')];
    var  currentValue = $filter.data('currentValue');

    if (typeof options == 'undefined') {
      $filter.html('').select2({data: null});
      $filter.prop('disabled', true);
      return;
    }

    $filter.prop('disabled', false);

    options = options.map(function(option) {
      if (typeof option == 'object' && option.length == 2 && typeof option[1] != 'undefined') {
        return { id: option[1] || '', text: option[0] }
      } else {
        return { id: option, text: option }
      }
    });

    var selectOptions = { data: options };
    var includeBlank = $filter.data('includeBlank');

    if (includeBlank != null && typeof includeBlank != 'undefined') {
      options.unshift({ id: '', text: '' });

      selectOptions.allowClear = true;
      selectOptions.placeholder = $filter.data('includeBlank')
    }

    $filter.html('').select2(selectOptions);
    handleSelectChange($filter, false);

    if (currentValue != null && typeof currentValue != 'undefined') {
      $filter.val(currentValue).trigger('change');
    }
  }

  $(function() {
    $('select.nuntius-filter').each(function() {
      var $this = $(this);

      var selectOptions = {};
      var includeBlank = $this.data('includeBlank');
      if (includeBlank != null && includeBlank != 'undefined') {
        selectOptions.allowClear = true;
        selectOptions.placeholder = $this.data('includeBlank')
      }

      $(this).select2(selectOptions)
        .on('select2:select', function() { handleSelectChange(this, false) })
        .on('select2:unselect', function() { handleSelectChange(this, true) });
      handleSelectChange(this, false);
    })

  });

})();
