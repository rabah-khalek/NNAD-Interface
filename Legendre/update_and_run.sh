rm -r output1 output2 output3 output4
scp -r rabahak@login.nikhef.nl:/data/theorie/rabah/NNAD/tests/build1/run/output output1
python time_comparison_1layer.py
echo "time: '1layer' done."

scp -r rabahak@login.nikhef.nl:/data/theorie/rabah/NNAD/tests/build2/run/output output2
python time_comparison_2layers.py
echo "time: '2layers' done."

scp -r rabahak@login.nikhef.nl:/data/theorie/rabah/NNAD/tests/build3/run/output output3
python time_comparison_3layers.py
echo "time: '3layers' done."

scp -r rabahak@login.nikhef.nl:/data/theorie/rabah/NNAD/tests/build4/run/output output4
python time_comparison_4layers.py
echo "time: '4layers' done."

python time_combine.py log
python time_combine.py linear

