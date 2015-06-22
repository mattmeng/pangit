module Pangit
	module Exceptions
		class PangitException < StandardError; end

		# Data Store Exceptions
		class DSRoomAlreadyExists < PangitException; end
		class DSUserAlreadyExists < PangitException; end

		class UserNameInvalid < PangitException; end
		class UserSessionIDInvalid < PangitException; end

		class RoomNameInvalid < PangitException; end
		class RoomInvalidUser < PangitException; end
		class RoomUserAlreadyExists < PangitException; end
	end
end