# frozen_string_literal: true

# name: test-tagger
# about: Add an "unhandled" tag to every topic where non-staff post
# version: 0.1
# authors: Sam Saffron, Renee Sullivan

# other files used:
# config/settings.yml: defines the 'unhandled' tag.
# spec/plugin_spec.rb: just a test?
# config/locales/client.en.yml: related to a button
# assets/javascripts/connectors... related to a button I don't need

# to do: change from post_created to topic_created
after_initialize do
  DiscourseEvent.on(:topic_created) do |topic, _, _|
    next if SiteSetting.test_tag.blank?
    #next if user.staff?
    next if topic.private_message?

    # username = topic.user.user_fields.name
    username = "testing-username-tag"

  #  tag = Tag.find_or_create_by!(name: SiteSetting.test_tag)
  tag = Tag.find_or_create_by!(name: username)

    ActiveRecord::Base.transaction do
      #topic = post.topic
      # if the topic does not already contain this tag,
      if !topic.tags.pluck(:id).include?(tag.id)
        topic.tags.reload
        topic.tags << tag
        topic.save
      end
    end
  end
end
