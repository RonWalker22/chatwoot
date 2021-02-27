# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersAccountsInsertOrFeedbacksInsert < ActiveRecord::Migration[6.0]
  def up
    drop_trigger('accounts_after_insert_row_tr', 'accounts', generated: true)

    create_trigger('accounts_after_insert_row_tr', generated: true, compatibility: 1)
      .on('accounts')
      .after(:insert)
      .for_each(:row) do
      <<-SQL_ACTIONS
  execute format('create sequence IF NOT EXISTS conv_dpid_seq_%s', NEW.id);
     execute format('create sequence IF NOT EXISTS feedb_dpid_seq_%s',
      NEW.id);
      SQL_ACTIONS
    end

    create_trigger('feedbacks_before_insert_row_tr', generated: true, compatibility: 1)
      .on('feedbacks')
      .before(:insert)
      .for_each(:row) do
      "NEW.display_id := nextval('feedb_dpid_seq_' || NEW.account_id);"
    end
  end

  def down
    drop_trigger('accounts_after_insert_row_tr', 'accounts', generated: true)

    drop_trigger('feedbacks_before_insert_row_tr', 'feedbacks', generated: true)

    create_trigger('accounts_after_insert_row_tr', generated: true, compatibility: 1)
      .on('accounts')
      .after(:insert)
      .for_each(:row) do
      "execute format('create sequence IF NOT EXISTS conv_dpid_seq_%s', NEW.id);"
    end
  end
end
