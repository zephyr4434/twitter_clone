require 'spec_helper'

describe "Static Pages" do

	subject { page }

	describe "Home page" do
		before { visit root_path }

		it { should have_selector('h1', text: 'Twitter Clone') }
		it { should have_selector('title', text: full_title('Home')) }

	end

		describe "Help" do
			before { visit help_path }

		it { should have_selector('h1', text: 'Help') }
		it { should have_selector('title', text: full_title('Help')) }
	end

		describe "About" do
			before { visit about_path }

		it { should have_selector('h1', text: 'About') }
		it { should have_selector('title', text: full_title('About')) }
	end

		describe "Contact Us" do
			before { visit contact_path }

		it { should have_selector('h1', text: 'Contact Us') }
		it { should have_selector('title', text: full_title('Contact Us')) }
	end

end