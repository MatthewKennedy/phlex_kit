# frozen_string_literal: true

module Docs
  module Examples
    module Card
      class LoginForm < Phlex::HTML
        def view_template
          render PhlexKit::Card.new(class: "w-md") do
            render PhlexKit::CardHeader.new do
              render PhlexKit::CardTitle.new { "Login to your account" }
              render PhlexKit::CardDescription.new { "Enter your email below to login to your account" }
              render PhlexKit::CardAction.new do
                render PhlexKit::Button.new(variant: :link) { "Sign Up" }
              end
            end
            render PhlexKit::CardContent.new do
              div(class: "stack") do
                render PhlexKit::FormField.new do
                  render PhlexKit::FormFieldLabel.new(for: "card-email") { "Email" }
                  render PhlexKit::Input.new(type: :email, id: "card-email", placeholder: "m@example.com", required: true)
                  render PhlexKit::FormFieldError.new
                end
                render PhlexKit::FormField.new do
                  div(class: "row", style: "justify-content: space-between") do
                    render PhlexKit::FormFieldLabel.new(for: "card-password") { "Password" }
                    render PhlexKit::InlineLink.new(href: "#", style: "font-size:.875rem") { "Forgot your password?" }
                  end
                  render PhlexKit::Input.new(type: :password, id: "card-password", required: true)
                  render PhlexKit::FormFieldError.new
                end
              end
            end
            render PhlexKit::CardFooter.new(style: "flex-direction: column; gap: .5rem") do
              render PhlexKit::Button.new(style: "width:100%") { "Login" }
              render PhlexKit::Button.new(variant: :outline, style: "width:100%") { "Login with Google" }
            end
          end
        end
      end
    end
  end
end
