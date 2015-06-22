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
	end
end