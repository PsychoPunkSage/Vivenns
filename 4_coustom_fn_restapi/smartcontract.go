// TEST:: CountAllAssets returns number of assets. <<@author :: PsychoPunkSage>>
func (s *SmartContract) CountAllAssets(ctx contractapi.TransactionContextInterface) (uint16, error) {
	resutlsIterator, err := ctx.GetStub().GetStateByRange("", "")
	if err != nil {
		return 0, err
	}
	defer resutlsIterator.Close()

	numAssets := 0

	for resutlsIterator.HasNext() {
		_, err := resutlsIterator.Next()
		if err != nil {
			return 0, err
		}

		numAssets = numAssets + 1
	}

	return uint16(numAssets), nil
}