#!/bin/bash

source uts.shi

utsfn_main()
{
	uts.err "\n";
	eval "$@";
	uts.err "\n";
	uts.err "\n";
}

utsfn_main "$@"
