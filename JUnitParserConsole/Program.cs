using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Xml;
using System.Xml.Xsl;

namespace TrxerConsole
{
    class Program
    {
        /// <summary>
        /// Embedded Resource name
        /// </summary>
        private const string XML_XSLT_FILE = "JUnit.xslt";

        /// <summary>
        /// Trxer output format
        /// </summary>
        private const string OUTPUT_FILE_EXT = ".html";

        /// <summary>
        /// Main entry of TrxerConsole
        /// </summary>
        /// <param name="args">First cell shoud be TRX path</param>
        static void Main(string[] args)
        {
            if (args.Any() == false)
            {
                Console.WriteLine("No file,  junitParserConsole.exe <filename>");
                return;
            }
            Console.WriteLine("Xml File\n{0}", args[0]);

            Transform(args[0], PrepareXsl(XML_XSLT_FILE));
        }

        /// <summary>
        /// Transforms trx int html document using xslt
        /// </summary>
        /// <param name="fileName">Trx file path</param>
        /// <param name="xsl">Xsl document</param>
        private static void Transform(string fileName, XmlDocument xsl)
        {
            XslCompiledTransform x = new XslCompiledTransform(true);
            x.Load(xsl, new XsltSettings(true, true), null);
            Console.WriteLine("Transforming...");
            x.Transform(fileName, fileName + OUTPUT_FILE_EXT);
            Console.WriteLine("Done transforming xml into html");
        }

        /// <summary>
        /// Loads xslt form embedded resource
        /// </summary>
        /// <returns>Xsl document</returns>
        private static XmlDocument PrepareXsl(string document)
        {
            XmlDocument xslDoc = new XmlDocument();
            Console.WriteLine("Loading xslt template...");
            xslDoc.Load(ResourceReader.StreamFromResource(document));
            MergeCss(xslDoc);
            return xslDoc;
        }

        /// <summary>
        /// Merges all css linked to page ito Trxer html report itself
        /// </summary>
        /// <param name="xslDoc">Xsl document</param>
        private static void MergeCss(XmlDocument xslDoc)
        {
            Console.WriteLine("Loading css...");
            XmlNode headNode = xslDoc.GetElementsByTagName("head")[0];
            XmlNodeList linkNodes = xslDoc.GetElementsByTagName("link");
            List<XmlNode> toChangeList = linkNodes.Cast<XmlNode>().ToList();

            foreach (XmlNode xmlElement in toChangeList)
            {
                XmlElement styleEl = xslDoc.CreateElement("style");
                styleEl.InnerText = ResourceReader.LoadTextFromResource(xmlElement.Attributes["href"].Value);
                headNode.ReplaceChild(styleEl, xmlElement);
            }
        }
    }
}
