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
  DiscourseEvent.on(:topic_created) do |topic, _, user|
    next if SiteSetting.test_tag.blank?
    #next if user.staff?
    next if topic.private_message?



# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# add sexual orientation tag

  username = "start---"

    if user.custom_fields == nil
      username = "custom-fields-is-nil"
    else
      if user.custom_fields.keys == nil
        username = "keys-is-nil"
      else
        if user.custom_fields.keys.length == nil
          username = "length-is-nil"
        else
          if user.custom_fields.keys[0] == nil
            username = "first-key-is-nil"
          else
            #username.concat(user.custom_fields.keys.length.to_s)
            usename.concat("---")

        #  user.custom_fields.keys.each do |item|
        #      username.concat(item)
        #      username.concat("---")
        #    end

            username.concat("$$$$")

            #user.custom_fields.values.each do |item|
            #  username.concat(item)
            #  username.concat("---")
            #end

          end
        end
      end
    end

    username = username.downcase
    username = username.sub(" ","xxxx")

    #username = user.user_fields.name
    #username = "testing-username-tag"
    # username = user.custom_fields['sexual_orientation']

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

    # ----------------------------------------------------------------------
    # ----------------------------------------------------------------------
    # add sex tag


    # ----------------------------------------------------------------------
    # ----------------------------------------------------------------------
    # add transition history tag


    # ----------------------------------------------------------------------
    # ----------------------------------------------------------------------
    # add generaiton tag


  end # end on(topic_created)
end # end after_initialize
