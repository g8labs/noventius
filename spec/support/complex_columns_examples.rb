module ComplexColumnsExamples

  def complex_columns_1 # rubocop:disable Metrics/MethodLength
    {
      'Date' => {
        rowspan: 2
      },
      'Offer_1' => {
        colspan: 3,
        rowspan: 1,
        children: {
          'Event_1' => {},
          'Event_2' => {},
          'Event_3' => {}
        }
      },
      'Offer_2' => {
        colspan: 3,
        rowspan: 1,
        children: {
          'Event_1' => {},
          'Event_2' => {},
          'Event_3' => {}
        }
      }
    }
  end

  def complex_columns_1_level_1
    [
      ['Date', { rowspan: 2 }],
      ['Offer_1', { colspan: 3,
                    rowspan: 1,
                    children: {
                      'Event_1' => {},
                      'Event_2' => {},
                      'Event_3' => {} } }
      ],
      ['Offer_2', { colspan: 3,
                    rowspan: 1,
                    children: {
                      'Event_1' => {},
                      'Event_2' => {},
                      'Event_3' => {} } }
      ]
    ]
  end

  def complex_columns_1_level_2
    [
      [:rowspan, 2],
      [:colspan, 3],
      [:rowspan, 1],
      [:children, { 'Event_1' => {}, 'Event_2' => {}, 'Event_3' => {} }],
      [:colspan, 3],
      [:rowspan, 1],
      [:children, { 'Event_1' => {}, 'Event_2' => {}, 'Event_3' => {} }]
    ]
  end

  def complex_columns_1_level_3
    [
      ['Event_1', {}],
      ['Event_2', {}],
      ['Event_3', {}],
      ['Event_1', {}],
      ['Event_2', {}],
      ['Event_3', {}]
    ]
  end

end
