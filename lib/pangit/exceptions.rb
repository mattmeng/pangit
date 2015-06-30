module Pangit
	module Exceptions
		class PangitException < StandardError; end

		# Data Store Exceptions
		class DataStoreInvalidKey < PangitException; end
		class DataStoreInvalidStore < PangitException; end
		class DataStoreAlreadyExists < PangitException; end

    # Users Exceptions
    class UserSessionIDAlreadyExists < PangitException; end
    class UserNameInvalid < PangitException; end
    class UserSessionIDInvalid < PangitException; end

    # Rooms Exceptions
    class RoomIDAlreadyExists < PangitException; end
		class RoomIDInvalid < PangitException; end
		class RoomNameInvalid < PangitException; end
		class RoomInvalidUser < PangitException; end

    # CardSet Exceptions
    class CardSetInvalidType < PangitException; end
    class CardSetInvalidIDType < PangitException; end
    class CardSetInvalidNameType < PangitException; end
    class CardSetNameInvalid < PangitException; end
    class CardSetIDAlreadyExists < PangitException; end
	end
end