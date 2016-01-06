class User 
  #require 'neo4j/spatial'
  #extend Geocoder::Model::ActiveNode

  include Neo4j::ActiveNode
  #include Neo4j::ActiveNode::Spatial
  include Neo4jrb::Paperclip
    #
    # Neo4j.rb needs to have property definitions before any validations. So, the property block needs to come before
    # loading your devise modules.
    #
    # If you add another devise module (such as :lockable, :confirmable, or :token_authenticatable), be sure to
    # uncomment the property definitions for those modules. Otherwise, the unused property definitions can be deleted.
    #

     #attr_accessible :email, :password, :password_confirmation, :remember_me, :uid, :username, :provider

     property :username, type: String

     #Facebook properties for omniauth login
     property :facebook_token, type: String
     index :facebook_token
     property :provider, :type => String, :index => :exact
     property :uid, :type => String, :index => :exact
     property :username, :type => String, :index => :exact
     property :tokensecret, :type => String
     property :tokendate, :type => Date
     property :location, :type => String
     #property :lat, :type => Float
     #property :lon, :type => Float

     include Gravtastic
     gravtastic


     #for geolocation
     #geocoded_by :location
     #after_validation :location, :if => :location_changed?
     #spatial_index 'users'
     #after_save :geocode

     property :created_at, type: DateTime
     property :updated_at, type: DateTime

     ## Database authenticatable
     property :email, type: String, null: false, default: ""
     index :email

     property :encrypted_password

     ## If you include devise modules, uncomment the properties below.

     ## Rememberable
     property :remember_created_at, type: DateTime
     property :remember_token
     index :remember_token


     ## Recoverable
     property :reset_password_token
     index :reset_password_token
     property :reset_password_sent_at, type: DateTime

     ## Trackable
     property :sign_in_count, type: Integer, default: 0
     property :current_sign_in_at, type: DateTime
     property :last_sign_in_at, type: DateTime
     property :current_sign_in_ip, type:  String
     property :last_sign_in_ip, type: String

     #additional properties
     property :birthday, type: Date
     property :country, type: String
     property :gender, type: String
     property :status, type: String
     property :biography, type: String
     property :gender_preference, type: String
     property :age_preference, type: Integer

     #add the avatar for user
     has_neo4jrb_attached_file :avatar
     validates_attachment_content_type :avatar, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]


     #defining relationships
     #relationship for user [HAS_INTEREST] interest
     has_many :out, :interests, type: :HAS_INTEREST, model_class: :Interest

     has_many :out, :following, type: :FOLLOWING, model_class: :User
     has_many :in, :followed_by, model_class: :User, origin: :following

     ## Confirmable
     # property :confirmation_token
     # index :confirmation_token
     # property :confirmed_at, type: DateTime
     # property :confirmation_sent_at, type: DateTime

     ## Lockable
     #  property :failed_attempts, type: Integer, default: 0
     # property :locked_at, type: DateTime
     #  property :unlock_token, type: String,
     # index :unlock_token

      ## Token authenticatable
      # property :authentication_token, type: String, null: true, index: :exact

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]


    def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
        
        user = User.where(:provider => auth.provider, :uid => auth.uid).first

        if Rails.env.development?
            $akey = ENV['DEV_AKEY']
            $asecret = ENV['DEV_ASECRET']
        else
            $akey = ENV['PROD_AKEY']
            $asecret = ENV['PROD_ASECRET']
        end

        if user
            if (Date.today - user.tokendate).to_i > 35
                $usertoken = User.where(:uid => user.uid).first
                @oauth = Koala::Facebook::OAuth.new($akey, $asecret)
                $oauthsecret = @oauth.exchange_access_token_info(auth.credentials.token)
                $usertoken.tokensecret = $oauthsecret["access_token"]
                $usertoken.tokendate = Date.today
                $usertoken.save
            end 

            #update profile image
            user.update_attribute(:avatar, auth.info.image)

        return user

        else
            registered_user = User.where(:email => auth.info.email).first
            if registered_user
                if (Date.today - registered_user.tokendate).to_i > 35
                    $usertoken = User.where(:uid => registered_user.uid).first
                    @oauth = Koala::Facebook::OAuth.new($akey, $asecret)
                    $oauthsecret = @oauth.exchange_access_token_info(auth.credentials.token)
                    $usertoken.tokensecret = $oauthsecret["access_token"]
                    $usertoken.tokendate = Date.today
                    $usertoken.save
                end 

                #update user image
                registered_user.update_attribute(:avatar, auth.info.image)

                return registered_user
            else
                @oauth = Koala::Facebook::OAuth.new($akey, $asecret)
                $oauthsecret = @oauth.exchange_access_token_info(auth.credentials.token)
                user = User.create(username:auth.extra.raw_info.name, #This is the information obtained from Facebook profil
                    provider:auth.provider,
                    uid:auth.uid,
                    #birthday:auth.extra.raw_info.b,
                    email:auth.info.email,
                    password:Devise.friendly_token[0,20],
                    tokensecret:$oauthsecret["access_token"],
                    tokendate:Date.today,
                    avatar: auth.info.image,
                    gender: auth.extra.raw_info.gender,
                    location: auth.extra.raw_info.location.name
                    )
            end
        end
    #end of facebook function
    end  

    

end
