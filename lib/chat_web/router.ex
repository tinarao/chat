defmodule ChatWeb.Router do
  alias ChatWeb.APIAuthController
  use ChatWeb, :router

  pipeline :api_auth do
    plug ChatWeb.Plugs.Auth
  end

  pipeline :api do
    plug CORSPlug,
      origin: ["http://localhost:3000"],
      credentials: true

    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    options "/*path", APIAuthController, :options

    # get "/messages/:topic", ChatWeb.APIMessagesController, :get_by_room

    post "/signup", APIAuthController, :signup
    post "/login", APIAuthController, :login
    delete "/logout", APIAuthController, :logout

    get "/rooms/:topic", ChatWeb.APIRoomsController, :show

    pipe_through :protected
    get "/me", APIAuthController, :me

    get "/rooms/get/my", ChatWeb.APIRoomsController, :get_my_rooms
    post "/rooms/create", ChatWeb.APIRoomsController, :create

    patch "/rooms/allow_anonyms/:room_id/:allow_anonyms",
          ChatWeb.APIRoomsController,
          :switch_allow_anonyms
  end

  pipeline :protected do
    plug ChatWeb.Plugs.Protected
  end

  if Application.compile_env(:chat, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ChatWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
