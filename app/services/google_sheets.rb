# frozen_string_literal: true
require "google_drive"

module Vitae
  # Service object to create a new sheet for an owner
  class GoogleSheets
    def initialize
      @session = GoogleDrive::Session.from_service_account_key(nil)
    end

    def new_sheet(email:, title:, template_id:)
      newsheet = @session.file_by_id(template_id).duplicate(title)
      user_folder(email).add(newsheet)
      newsheet.acl.push({type: "user", email_address: email, role: "writer"},
                        {send_notification_email: false})
      {file_id: newsheet.id, title: newsheet.title}
    end

    def sheet_data(file_id:)
      puts 'hello'
      spreadsheet = @session.file_by_id(file_id)
      puts spreadsheet.inspect
      worksheets = spreadsheet.worksheets
      puts worksheets.inspect
      # worksheets.each do |ws|
      #   puts ws.rows
      # end
    end

    # private

    def user_folder(email)
      drive = @session.file_by_id('root')
      top = drive.subfolder_by_name('Root') || drive.create_subfolder('Root')
      # aclf = top.acl.push(
      #    {type: "user", email_address: "vitae2app@gmail.com", role: "writer"},
      #    {send_notification_email: false})
      # exit
      top.subfolder_by_name(email) || top.create_subfolder(email)
    end
  end
end