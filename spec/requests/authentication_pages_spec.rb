require 'spec_helper'

describe "AuthenticationPages" do

subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { have_selector('h1', 'Sign in') }
		it { have_selector('title', full_title('Sign in')) }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }

			it { have_selector('title', 'Sign in') }
			it { have_error_message('Invalid') }

			describe "after visiting another page" do #testing for persistance of error
				before { click_link "Home" } #referring to the actual link text in the header
				it { not_have_error }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			it { have_selector('title', user.name) }

			it { should have_link('Users', href: users_path) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }

			it { should_not have_link('Sign in', href: signin_path) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end

		describe "signed in and trying to access new action" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
				visit signin_path
			end

			it { have_selector('title', 'Home') }
		end

		describe "signed in and trying to access create action" do
			let!(:user) { FactoryGirl.create(:user) }

			before do 
				sign_in user
				visit signup_path 
			end

			it { have_selector('title', 'Home') }
		end

	end

	describe "Authorization" do

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			it { should_not have_link('Users', href: users_path) }
			it { should_not have_link('Profile', href: user_path(user)) }
			it { should_not have_link('Settings', href: edit_user_path(user)) }
			it { should_not have_link('Sign out', href: signout_path) }	

			describe "in the Users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { have_selector('title', 'Sign in') }
				end

				describe "submitting to the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end

				describe "visiting the user index" do
					before { visit users_path }
					it { have_selector('title', 'Sign in') }
				end

				describe "visiting the following page" do
					before { visit following_user_path(user) }
					it { have_selector('title', "Sign in") }
				end

				describe "visiting the followers page" do
					before { visit followers_user_path(user) }
					it { have_selector('title', 'Sign in') }
				end

			end

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					fill_in "Email", 		with: user.email
					fill_in "Password", 	with: user.password
					click_button "Sign in"
				end

				describe "after signing in" do

					it "should render the desired protected page" do
						have_selector('title', 'Edit user')
					end

				end
			end

			describe "as non-admin user" do
				let(:user) { FactoryGirl.create(:user) }
				let(:non_admin) { FactoryGirl.create(:user) }

				before { sign_in non_admin }

				describe "submitting a DELETE request to the Users#destroy action" do
					before { delete user_path(user) }
					specify { response.should redirect_to(root_path) }
				end
			end

			describe "in the microposts controller" do

				describe "submitting to the create action" do
					before { post microposts_path }
					specify { response.should redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before do
						micropost = FactoryGirl.create(:micropost)
						delete micropost_path(micropost)
					end
					specify { response.should redirect_to(signin_path) }
				end
			end

			describe "in the Relationships controller" do
				describe "submitting to the create action" do
					before { post relationships_path }
					specify { response.should redirect_to(signin_path) }
				end

			describe "submitting to the destroy action" do
					before { delete relationship_path(1) }
					specify { response.should redirect_to(signin_path) }
				end

			end

		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }	
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user }

			describe "visiting Users#edit page" do
				before { visit edit_user_path(wrong_user) }
				it { should_not have_selector('title', text: full_title('Edit user')) }
			end

			describe "submitting a PUT request to the Users#update action" do
				before { put user_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "destroy" do
		    let!(:admin) { FactoryGirl.create(:admin) }

		    before { sign_in admin }

		    it "should not allow the admin to delete herself" do
		    	expect { delete user_path(admin) }.not_to change(User, :count)
		    end
		end
	end
end
 










