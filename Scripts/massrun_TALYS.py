r'''
Copyright (c) 2025 Antero Voutilainen
Created: 30 10 2025

Description: 
'''
from pathlib import Path

import argparse
import pandas as pd
import numpy as np
import datetime as dt
import os


def parse_data(data_path):
    """Parses excel data for processes and nucleus information.

    Args:
        data_path (Path):   Pathlib object to the data excel

    Returns:
        dataframe: Returns two dataframes that include sheets from excel.
    """    
    sheet1 = pd.read_excel(data_path, sheet_name="Sheet1")
    sheet2 = pd.read_excel(data_path, sheet_name="Sheet2")
    
    nucl_info = sheet1[["Ydin", "N", "Z", "A", "MEJYFL", "MEAME20"]]
    
    reactions = sheet2[["Target", 
                      "Projectile", 
                      "Ejectile", 
                      "Compound"]]
    
    return nucl_info, reactions


def make_dir(projectile, target, l, s, m, runs):
    """Creates new directory with specific name format for given process.

    Args:
        projectile (string):    Projectile included in process
        target (string):        Target included in process
        l (int):                Ldmodel (TALYS parameter)
        s (int):                Strength (TALYS parameter)
        m (int):                Massmdoel (TALYS parameter)
        runs (Path):            pathlib object to root folder where 
                                directories are wished to be created

    Returns:
        string: name for run directory
    """    
    TIME = dt.datetime.now()
    today = TIME.strftime("%d%m%y")
    
    # Specify the directory name
    directory_name = "Run-"+str(today)+"_"+str(projectile)+str(target)+"-"+str(l)+str(s)+str(m)
    directory_path = Path(runs) / directory_name
    
    print(f"\nCreating directory with the name: \n{directory_name}")
    print(f"\nTo the Path: \n{runs}")
    
    # Create the directory
    try:
        directory_path.mkdir(parents=True, exist_ok=False)
        print(f"\nDirectory '{directory_name}' created successfully.")
    except FileExistsError:
        print(f"\nDirectory '{directory_name}' already exists.")
    except PermissionError:
        print(f"\nPermission denied: Unable to create '{directory_name}'.")
    except Exception as e:
        print(f"\nAn error occurred: {e}")
    return directory_name


def make_input(nucl_info, reactions, process, l, s, m, runs, run_dir_name):
    """Creates input file for given process talys run.

    Args:
        nucl_info (dataframe):  Dataframe that includes nucleus 
                                data needed for input file
        reactions (dataframe):  Dataframe that includes processes from which
                                specific is chosen.
        process (int):          Chooses the process.
        l (int):                Ldmodel (TALYS parameter)
        s (int):                Strength (TALYS parameter)
        m (int):                Massmdoel (TALYS parameter)
        runs (Path):            Path to run root directory where 
                                input file is created.
        run_dir_name (string):  Name for input file, same as the directory 
                                it is created.
    """    
    input_path = Path(runs / run_dir_name / f"{run_dir_name}_input.txt")
    
    target = reactions["Target"][process]
    projectile = reactions["Projectile"][process]
    
    # Look up target Z,A
    row = nucl_info.loc[nucl_info["Ydin"] == target].iloc[0]
    Z_target = int(row["Z"])
    A_target = int(row["A"])
    
    # TODO: Add choise for JYFL / AME mass excesses
    # TODO: Also think about errors?
    ME_colum = nucl_info["MEJYFL"]
    
     # Ensure numeric and drop rows missing any of Z, A, ME
    df_me = nucl_info.assign(
        Z_num=pd.to_numeric(nucl_info["Z"], errors="coerce"),
        A_num=pd.to_numeric(nucl_info["A"], errors="coerce"),
        ME_num=pd.to_numeric(ME_colum, errors="coerce"),
    ).dropna(subset=["Z_num", "A_num", "ME_num"])
    
    def write_input(f):
        """Writes content to input file.

        Args:
            f (file): file to write on.
        """        
        f.write(f"energy {0.1}\n")
        f.write(f"projectile {projectile}\n") # Projectile
        f.write(f"element {int(Z_target)}\n") # Target element
        f.write(f"mass {int(A_target)}\n") # Mass number of target
        f.write(f"ldmodel {l}\n") 
        f.write(f"strength {s}\n")
        f.write(f"massmodel {m}\n")
        f.write(f"astro y\n") # Astrophysical regime
        f.write(f"transeps {1.0E-25}\n")
        f.write(f"xseps {1.0E-25}\n")
        f.write(f"popeps {1.0E-25}\n")
        f.write(f"gnorm y\n")
        f.write(f"outlevels y\n")
        f.write(f"outdensity y\n")
        f.write(f"outgamma y\n")
        f.write(f"expmass y\n")
        
         # One line per available mass-excess: massexcess Z A ME
        for Z, A, ME in df_me[["Z_num", "A_num", "ME_num"]].itertuples(index=False, name=None):
            f.write(f"massexcess {int(Z)} {int(A)} {float(ME):.3f}\n")
        return
    
    try:
        print(f"\nCreated new input file with name {run_dir_name}_input.txt.")
        with open(input_path, "x") as f:
            write_input(f)
    except FileExistsError:
        print(f"\nWarning: File already exists. Overwriting to existing file...")
        with open(input_path, "w") as f:
            write_input(f)
    return


def make_run():
    """Gives the run command to talys.
    """    
    
    return


def main(args):
    """Main function

    Args:
        args (argparse dictionary): Arguments passed from CLI.
    """    
    RUNS_PATH = Path(args.runs)
    DATA_PATH = Path(args.data)
    ldmodel = args.ldmodel
    strength = args.strength
    massmodel = args.massmodel
    
    # TODO: give choise for one run or multiple from CLI
    process = 0
    
    # print(RUNS)
    # print(DATA)
    
    nucl_info, reactions = parse_data(DATA_PATH)
    
    target = reactions["Target"][process]
    projectile = reactions["Projectile"][process]
    print(target)
    print(projectile)
    
    print(f"\nListed processes in Excel: \n{reactions}")
    print(f"\nAnd relevant nuclear information available: \n{nucl_info}")
    
    run_dir = make_dir(projectile, target, ldmodel, strength, massmodel, RUNS_PATH)
    make_input(nucl_info, reactions, process, ldmodel, strength, massmodel, RUNS_PATH, run_dir)
    
    return


def build_parser():
    """Helper function that builds CLI parser.

    Returns:
        argparse object: CLI argument parser.
    """    
    ap = argparse.ArgumentParser(
        description="Script to Initiate run(s) for TALYS from given data excel.")
    ap.add_argument('runs', help='Path to run root directory.')
    ap.add_argument('data', help='Path to data root directory.')
    ap.add_argument('--ldmodel', type=int, default=5, 
                    help="Ldmodel parameter for TALYS.")
    ap.add_argument('--strength', type=int, default=8, 
                    help="Strength parameter for TALYS.")
    ap.add_argument('--massmodel', type=int, default=2, 
                    help="Massmodel parameter for TALYS.")
    
    return ap


if __name__ == "__main__":
    # DEBUG = True
    DEBUG = False
    
    parser = build_parser()
    if DEBUG:
        fake = [r"\\wsl.localhost\Ubuntu\home\antero\projects\Masters_Thesis\Simulation\TALYS\TEST_dirs", 
                r"C:\Users\anter\Documents\Gradu\Masters_Thesis\Data\MassExcess-Antero-v2.xlsx"]
        args = parser.parse_args(fake)
    else:
        args = parser.parse_args()
    
    main(args)

