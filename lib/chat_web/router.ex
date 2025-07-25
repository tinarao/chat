defmodule ChatWeb.Router do
  alias ChatWeb.APIAuthController
  use ChatWeb, :router

  pipeline :api_auth do
    plug ChatWeb.Plugs.Auth
  end

  pipeline :api do
    plug CORSPlug,
      origin: ["http://localhost:3000"]

    plug :accepts, ["json"]
  end

  scope "/api", ChatWeb do
    pipe_through :api

    options "/login", APIAuthController, :options
    options "/signup", APIAuthController, :options
    options "/logout", APIAuthController, :options

    resources "/users", UserController, only: [:index, :show]
    resources "/rooms", RoomController, only: [:index, :show]
    resources "/messages", MessageController, only: [:create]

    post "/signup", APIAuthController, :signup
    post "/login", APIAuthController, :login
    delete "/logout", APIAuthController, :logout
    get "/me", APIAuthController, :me
  end

  pipeline :protected do
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
