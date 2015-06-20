module Pangit
	module Exceptions
		class PangitException < StandardError; end

		# Data Store Exceptions
		class DSRoomAlreadyExists < PangitException; end

		class UserNameInvalid < PangitException; end
		class UserSessionIDInvalid < PangitException; end

		class RoomInvalidUser < PangitException; end
	end
end