FactoryGirl.define do
  factory :incident_data, class:Hash do
    defaults = {
      "name" => "Test Incident Name",
      "status" => "completed",
      "created_at" => "2017-06-23T10:57:37.141-07:00",
      "updated_at" => "2017-06-25T05:30:49.637-07:00",
      "monitoring_at" => nil,
      "resolved_at" => "2017-06-25T05:30:49.305-07:00",
      "impact" => "maintenance",
      "shortlink" => "http://stspg.io/aaaaaaa",
      "postmortem_ignored" => true,
      "postmortem_body" => nil,
      "postmortem_body_last_updated_at" => nil,
      "postmortem_published_at" => nil,
      "postmortem_notified_subscribers" => false,
      "postmortem_notified_twitter" => false,
      "backfilled" => false,
      "scheduled_for" => "2017-06-24T21:00:00.000-07:00",
      "scheduled_until" => "2017-06-25T05:30:00.000-07:00",
      "scheduled_remind_prior" => true,
      "scheduled_reminded_at" => "2017-06-25T02:59:37.165Z",
      "impact_override" => nil,
      "scheduled_auto_in_progress" => true,
      "scheduled_auto_completed" => true,
      "id" => "fakeid123",
      "page_id" => "fakepageid12345",
      "incident_updates" => [
        {
          "status" => "completed",
          "body" => "The scheduled maintenance has been completed.",
          "created_at" => "2017-06-25T05:30:49.305-07:00",
          "wants_twitter_update" => false,
          "twitter_updated_at" => nil,
          "updated_at" => "2017-06-25T05:30:49.305-07:00",
          "display_at" => "2017-06-25T05:30:49.305-07:00",
          "affected_components" => [
            {
              "com1id" => "Component 1"
            },
            {
              "com2id" => "Component 2"
            }
          ],
          "custom_tweet" => nil,
          "id" => "fakeid123",
          "incident_id" => "fakeincid123"
        },
        {
          "status" => "in_progress",
          "body" => "Scheduled maintenance is currently in progress. We will provide updates as necessary.",
          "created_at" => "2017-06-24T21:00:04.897-07:00",
          "wants_twitter_update" => false,
          "twitter_updated_at" => nil,
          "updated_at" => "2017-06-24T21:00:04.897-07:00",
          "display_at" => "2017-06-24T21:00:04.897-07:00",
          "affected_components" => [
            {
              "com1" => "Component 1"
            },
            {
              "com2" => "Component 2"
            }
          ],
          "custom_tweet" => nil,
          "id" => "fakeid123",
          "incident_id" => "fakeincid123"
        },
        {
          "status" => "scheduled",
          "body" => "Maintenance will begin as scheduled in 60 minutes.",
          "created_at" => "2017-06-24T19:59:37.021-07:00",
          "wants_twitter_update" => false,
          "twitter_updated_at" => nil,
          "updated_at" => "2017-06-24T19:59:37.021-07:00",
          "display_at" => "2017-06-24T19:59:37.021-07:00",
          "affected_components" => nil,
          "custom_tweet" => nil,
          "id" => "fakeid123",
          "incident_id" => "fakeincid123"
        }
      ],
      "components" => [
        {
          "status" => "operational",
          "name" => "Component 1",
          "created_at" => "2016-06-30T23:42:07.836Z",
          "updated_at" => "2017-06-27T02:51:46.488Z",
          "position" => 1,
          "description" => "Component 1 Environment",
          "showcase" => false,
          "id" => "com1id",
          "page_id" => "fakepageid12345",
          "group_id" => "fakegroupid"
        },
        {
          "status" => "operational",
          "name" => "Component 2",
          "created_at" => "2016-02-18T16:20:32.471Z",
          "updated_at" => "2017-04-26T23:49:20.241Z",
          "position" => 3,
          "description" => nil,
          "showcase" => false,
          "id" => "com2id",
          "page_id" => "fakepageid12345",
          "group_id" => "fakegroupid"
        }
      ],
      "highlight" => {
        "name" => [
          "Product <strong class=\"es-highlight\">Maintenance</strong> (PROD) - 06/24"
        ],
        "incident_updates.body" => [
          "The scheduled <strong class=\"es-highlight\">maintenance</strong> has been completed."
        ]
      }
    }

    initialize_with { defaults.merge(attributes.stringify_keys) }
  end

  factory :incident do
    name "Test Incident"

    trait :completed do
      status "resolved"
    end

    factory :maintenance_incident do
      impact "maintenance"

      trait :completed do
        status "completed"
      end
    end

    trait :in_progress do
      status "in_progress"
    end 

    trait :scheduled do
      status "scheduled"
    end
  end
end
