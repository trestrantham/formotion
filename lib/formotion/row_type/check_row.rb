motion_require 'base'

module Formotion
  module RowType
    class CheckRow < Base
      include BW::KVO

      def update_cell_value(cell)
        cell.accessoryType = cell.editingAccessoryType = row.value ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
      end

      # This is actually called whenever again cell is checked/unchecked
      # in the UITableViewDelegate callbacks. So (for now) don't
      # instantiate long-lived objects in them.
      # Maybe that logic should be moved elsewhere?
      def build_cell(cell)
        cell.textLabel.font = BW::Font.new(row.font) if row.font
        cell.selectionStyle = self.row.selection_style || UITableViewCellSelectionStyleBlue
        update_cell_value(cell)
        observe(self.row, "value") do |old_value, new_value|
          update_cell_value(cell)
        end
        nil
      end

      def on_select(tableView, tableViewDelegate)
        if !row.editable?
          return
        end
        if row.section.select_one and !row.value
          row.section.rows.each do |other_row|
            other_row.value = (row == other_row)
          end
        elsif !row.section.select_one
          row.value = !row.value
        end
      end

    end
  end
end
