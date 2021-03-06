class CreateVariables < ActiveRecord::Migration
      extend Inkling::Util::MigrationHelpers
  
  def self.up
    create_table :variables do |t|
      t.integer   :study_id #don't confuse with stdy_id - a string from nesstar
      t.string    :nesstar_id #maps to varchar id in variableejb mysql table
      t.text      :additivity
      t.text      :comment
      t.text      :concept
      t.datetime  :creation_date
      t.string    :datafile_id
      t.integer   :decimal_places
      t.integer   :end_pos
      t.text      :expression
      t.text      :ext_notes_role
      t.text      :ext_notes_title
      t.text      :ext_notes_uri
      t.string    :format
      t.string    :format_schema
      t.string    :geogr
      t.text      :instructions
      t.text      :interviewer_instr
      t.string    :intervl
      t.boolean   :is_key
      t.boolean   :is_weight
      t.text      :label
      t.decimal   :max_value
      t.decimal   :mean_value
      t.decimal   :median_value
      t.decimal   :min_value
      t.text      :missing_values
      t.decimal   :mode_value
      t.text      :name
      t.text      :nature
      t.integer   :no_invalid_responses
      t.text      :no_responses
      t.integer   :no_valid_responses
      t.text      :notes
      t.text      :origin
      t.integer   :position
      t.text      :post_question_text
      t.text      :pre_question_text
      t.text      :question_text
      t.text      :scale
      t.text      :source
      t.integer   :start_pos
      t.decimal   :std_value
      t.string    :stdy_id
      t.text      :syntax
      t.text      :universe
      t.decimal   :val_range_max
      t.decimal   :val_range_min
      t.string    :var_id
      t.decimal   :weighted_mean_value
      t.decimal   :weighted_median_value
      t.decimal   :weighted_mode_value
      t.decimal   :weighted_no_valid_responses
      t.decimal   :weighted_no_invalid_responses
      t.decimal   :weighted_std_value
      t.integer   :width
      t.timestamps
    end

    add_foreign_key(:variables, :study_id, :studies)
  end

  def self.down
    drop_table :variables
  end
end
