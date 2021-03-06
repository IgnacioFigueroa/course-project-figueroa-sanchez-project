require "application_system_test_case"

class FollowPostsTest < ApplicationSystemTestCase
  setup do
    @follow_post = follow_posts(:one)
  end

  test "visiting the index" do
    visit follow_posts_url
    assert_selector "h1", text: "Follow Posts"
  end

  test "creating a Follow post" do
    visit follow_posts_url
    click_on "New Follow Post"

    fill_in "Post", with: @follow_post.post
    fill_in "User", with: @follow_post.user
    click_on "Create Follow post"

    assert_text "Follow post was successfully created"
    click_on "Back"
  end

  test "updating a Follow post" do
    visit follow_posts_url
    click_on "Edit", match: :first

    fill_in "Post", with: @follow_post.post
    fill_in "User", with: @follow_post.user
    click_on "Update Follow post"

    assert_text "Follow post was successfully updated"
    click_on "Back"
  end

  test "destroying a Follow post" do
    visit follow_posts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Follow post was successfully destroyed"
  end
end
