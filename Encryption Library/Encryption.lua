--[[

    Made by Khayne Gleave.

    Encryption Notes:

    Output is dependable on seed.

    Attempt to Decrypt with none corresponding seed will result in fail.

    Ensure to change the seed upon every decryption (This is done by default)

    I HIGHLY SUGGEST NOT TO HOST THE DECODER ON THE CLIENT.

    I should also note that obscurity will help with the client Encoder, Use a obfuscator as clients can see the source.

]]


local Seed = 2

function Encode(Word) --> Type: [String] Only

	local EncryptedWord = ''

	Word = Word:reverse() --> Reverses the word to confuse any bruteforce decryptions as indexes are revsersed.

	for i = 1, #Word do

		local Index = string.byte(Word:sub(i, i)) --> Parses word by letter, Example "Test" Will be [T, e, s, t]

		Index += Seed --> Encrypts using seed

		EncryptedWord = EncryptedWord..utf8.char(Index)

	end

	return EncryptedWord

end

function Decode(Word)

	local DecryptedWord = ''

	Word=Word:reverse() --> Reverses word to correct indexes.

	for i=1,#Word do

		local Index = string.byte(Word:sub(i,i)) --> Parses word by letter, Example "Test" Will be [T, e, s, t]

		Index -= Seed --> Decrypts using seed

		DecryptedWord = DecryptedWord..string.char(Index)

	end

	DecryptedWord = DecryptedWord:gsub('%A', '') --> Removes all none Alphabet regex. [INCLUDES SPACES]

    Seed = math.random(1, 400)

	return DecryptedWord

end


--> Example Usage

local Input = Encode('This is to test my encoding :)')
local Output = Decrypt(Input)

print(Input, Output)